#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function, with_statement

import os, sys, subprocess, pickle, shutil, argparse, re
from multiprocessing import Pool
from tools_scons.filedata import FileDataTEX, FileDataSVG
from tools_scons.tools import *


os.chdir(os.path.dirname(os.path.abspath(__file__)))

# --------------- definition of local Classes -------------------------------
# TODO: this should/could be defined in other files in the tools-directory (maybe) --> for it the dependency on the "class" global has to be vanished (which is not as easy as you might think)

class Buffer:
    def __init__(self, version=None, tex=dict(), svg=dict(), sub=dict(), install=dict()):
        self.version=version
        self.tex=tex
        self.svg=svg
        self.sub=sub
        self.install=install

class Global:
    # TODO: get rid of this "class" and make it clean
        base_dir=os.path.abspath(os.path.join(os.path.dirname(__file__)))
        current_scr=__file__
        current_dir=base_dir

        tex=set()
        install=dict()
        script_paths=set()

        finished_compilation={'svg':[], 'tex':[]}

# --------------- end definition of local Classes ----------------------------

# --------------- definition of local Functions ------------------------------

def write_buffer(buf_file, buf, version):
    buf.version=version
    f=open(buf_file, 'wb')
    try:
        pickle.dump(buf, f, protocol=2)
    finally:
        f.close()

def base_path(path):
  return os.path.relpath(path, Global.base_dir)

def scan_files(endswith, maxdepth):
    return sf(endswith, Global.current_dir, maxdepth)

def add_files(files, install_path=None):
    for f in files:
        path=os.path.relpath(os.path.join(Global.current_dir, f), Global.base_dir)

        if not os.path.exists(path):
            red('\nFile not found: '+path)
            red('Added in '+Global.current_scr+'\n')
            raise Exception

        if path.endswith('.tex'):
            Global.tex.add(FileDataTEX(path))
        elif path.endswith('.svg'):
            if install_path==None:
                red('\nNo install path specified for: '+path)
                red('Added in: '+Global.current_scr+'\n')
                raise Exception
        else:
            red('\nSuffix not accepted: '+path)
            red('Only .tex and .svg are allowed.\n')
            raise Exception

        if install_path!=None:
            Global.install[path]=platform_path(install_path)

def SConscript(scripts):
    '''
    Read the Scons-Scripts to get the global tex-files that should be read

    '''

    parent_dir=Global.current_dir

    #Global.script_paths.add(scripts)

    for script in scripts:
        script=platform_path(script)

        script_file=os.path.join(parent_dir, script)

        # For repository check
        Global.script_paths.add(os.path.relpath(script_file, Global.base_dir))

        # Local SConscript file
        if os.path.exists(script_file+'_local') and arguments.repo==False and arguments.ignore_local==False:
            print('scons: Using local SConscript file: '+os.path.relpath(script_file+'_local', Global.base_dir))
            script_file=script_file+'_local'

        # For error messages
        Global.current_scr=script_file

        # For recursion
        Global.current_dir=os.path.dirname(script_file)

        exec(compile(open(script_file).read(), script_file, 'exec'), {'Global':Global, 'SConscript':SConscript, 'add_files':add_files, 'scan_files':scan_files})

def prepare_install(path):
  if not os.path.isdir(path):
    os.makedirs(path)


def print_progress():
  print('scons: \033[1;34m'+str(len(FileDataSVG.compilation) -
                                len(Global.finished_compilation['svg']))
        + '/' + str(len(FileDataSVG.compilation)) +
        '\033[1;m Inkscape files and \033[1;34m' +
        str(len(FileDataTEX.compilation)-len(Global.finished_compilation['tex']))
        + '/' + str(len(FileDataTEX.compilation)) +
        '\033[1;m LaTeX files remaining.')

# regex to check the pdf file
rxcountpages = re.compile(r"/Type\s*/Page([^s]|$)", re.MULTILINE|re.DOTALL)
rxcountrefs = re.compile('page=')

def fix_pdf_tex_bug(path):
    '''
    fix the bug of inkscape 0.91, where the pdf contains less pages than the
    pdf_tex file. The path is the path without the '.pdf' or the '.pdf_tex'-ending

    Furthermore fix the bug, that inkscape 0.91 returns some \\ inside the
    pdf_tex file, which causes LaTeX to crash.

    '''
    with open(path + '.pdf',"rb") as f:
        data_pdf = f.read().decode('utf8', 'ignore')
#    data_pdf = open(path + '.pdf',"rb").read()
    pages_pdf = len(rxcountpages.findall(data_pdf))

    with open(path + '.pdf_tex', 'r') as f:
        data_pdf_tex = f.readlines()
#    data_pdf_tex = file(path + '.pdf_tex', 'r').readlines()
    file_pdf_tex = open(path + '.pdf_tex', 'w')
    pagecounter = 0

    line_in_enviroment = False
    env_expression = 'pmatrix'

    for line in data_pdf_tex:
        # Remove line breaks only when not in enviroment pmatrix

        if re.search(r'\\begin{'+env_expression+'}',line):
            parts =re.split(r'(\\begin{'+env_expression+'})',line)
            parts[0] = parts[0].replace('\\\\', '')
            line = ''.join(parts)
            line_in_enviroment = True
        if re.search(r'\\end{'+env_expression+'}',line):
            parts =re.split(r'(\\end{'+env_expression+'})',line)
            parts[-1] = parts[-1].replace('\\\\', '')
            line = ''.join(parts)
            line_in_enviroment = False

        if not( re.search(r'\\begin{'+env_expression+'}',line) or re.search(r'\\end{'+env_expression+'}',line) or line_in_enviroment):
            line = line.replace('\\\\', '') # remove nasty line breaks which break LaTeX compatibility


        if rxcountrefs.search(line):
            pagecounter += 1
            if pagecounter <= pages_pdf:
                file_pdf_tex.write(line)
            else:
                file_pdf_tex.write('% The following line was commented out ' +
                                   ' by scons to resolve an inkscape bug. ' +
                                   'The pdf document has just ' +
                                   str(pages_pdf) + ' pages.\n')
                file_pdf_tex.write('%' + line)
                print('A line was commented in the pdf_tex file.')
        else:
            file_pdf_tex.write(line)

    file_pdf_tex.close()
    return

def compile_svg(path):
  '''
  Compilation of the svg file given in path
  '''
  print_progress()
  buf.svg[path].check_consistency(Global.install)

  if len(buf.svg[path].imported_in)>0:
      export_tex = '--export-latex'
  else:
      export_tex = ''
  try:
      # Bugfix as strange inkscape error occurs, when subprocess.check_output
      # is used.
      cmd = 'inkscape -z -D --export-pdf=' + \
            os.path.join(Global.base_dir, path)[0:-4] + '.pdf --file=' + \
            os.path.join(Global.base_dir, path) + ' ' + export_tex
      print('Compile:' + cmd)
      sys_out = os.system(cmd)
      if export_tex == '--export-latex':
          fix_pdf_tex_bug(os.path.join(Global.base_dir, path)[0:-4])
      # sys_out=subprocess.check_output(['inkscape', '-D', '-z', '--export-pdf='+os.path.join(Global.base_dir, path)[0:-4]+'.pdf', '--file='+os.path.join(Global.base_dir, path), export_tex], stderr=subprocess.STDOUT)
  except subprocess.CalledProcessError as grepexc:
      print("error code", grepexc.returncode, grepexc.output)
      sys.exit(10)

  if path in Global.install:
      install_path=Global.install[path]
      prepare_install(install_path)
      print('Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))
      shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))

  Global.finished_compilation['svg'].append(path)
  return sys_out

def compile_tex(path):
    '''
    Compile the tex file in the given path

    '''
    print_progress()

    latexcommand = ['pdflatex','--output-directory', os.path.dirname(path)]
    if arguments.silent:
        latexcommand.append('-interaction=batchmode')
    latexcommand.append(path)
    print('Compile: ' + ' '.join(latexcommand))

    bibercommand = ['biber', path[:-4]]

    if subprocess.call(latexcommand)!=0:
        FileDataTEX.tex_failed.append(path)

        red('\nCompilation error:\n'+path)

        checksum=0
        # changed in order to make the system running for gitlab
        raise Exception('Error in compiling the LaTeX code')
        sys.exit(1)

        if not arguments.silent:
            red('Press enter to continue.\n')
            if input()!='':
                red('Aborted\n')
    else:
        try:
            if arguments.silent:
                subprocess.check_output(bibercommand)
            else:
                subprocess.call(bibercommand)
        except:
            pass
        subprocess.call(latexcommand)
        subprocess.call(latexcommand)

        # Update the checksum if it is compiled correctly
        checksum=buf.tex[path].calculate_checksum()

    Global.finished_compilation['tex'].append(path)
    return (path, checksum)

def install_tex(path):
    '''
    Install the compiled tex directory
    '''
    # clean the directory from the unnecessary tex files (if successful)
    clean.clean_tex(path)

    # copy the necessary files into the directories
    if path in Global.install:
        install_path=Global.install[path]
        prepare_install(install_path)
        print('Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))
        shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))


# --------------- END definition of local Functions ----------------------------

# START OF the script

if __name__ == '__main__': #For windows-parallelization this is needed

    # -----------------SETTINGS-------------------------
    version=0.3
    buf_file='.buffer'
    clean_file='.clean'
    scripts=['documents/SConscript']
    # --------------------------------------------------

    # ------- ADD local paths to search for the classes and fonts ----
    # The TEXINPUTS variable is used by the programs to find the classes (kpsewhich uses it)
    # Here it is ensured that the classes/logos that are in the given path are used
    #   - The variable has to end with a path-seperator (Windows: ";", Unix/Linux: ":")
    # Adding the fonts follows http://tex.stackexchange.com/questions/84504/install-fonts-into-a-certain-directory-as-non-root
    texmfPath = os.path.join(os.getcwd(),'lib','texmf')
    texmfAMPath = os.path.join(texmfPath,'tex','latex')

    fontMapPath = os.path.join(texmfPath,'fonts','map') + '//' + os.pathsep
    fontPath = os.path.join(texmfPath,'fonts') + '//' + os.pathsep
    TEXINPUTSPATH = os.pathsep.join([os.path.join(texmfAMPath,'AM'),
                             os.path.join(texmfAMPath,'ressources','images') + '//',
                             os.path.join(texmfAMPath,'ressources','logos') + '//',
                             os.path.join(texmfAMPath,'tumhelvetica') + '//',
                             os.path.join(texmfPath,'fonts','enc','dvips','tumhelv') + '//',
                             os.path.join(texmfPath,'fonts','map','dvips','tumhelv') + '//',
                             os.path.join(texmfPath,'fonts','tfm','linotype','tumhelv') + '//',
                             os.path.join(texmfPath,'fonts','truetype','linotype','tumhelv') + '//',
                            ]) + os.pathsep

    for varName in ['TEXFONTMAPS']:
        try:
            os.environ[varName] = fontMapPath + os.environ[varName]
        except:
            os.environ[varName] = fontMapPath


    for varName in ['TEXINPUTS']:
        try:
            os.environ[varName] = TEXINPUTSPATH + os.environ[varName]
        except:
            os.environ[varName] = TEXINPUTSPATH

    for varName in ['ENCFONTS', 'TFMFONTS', 'T1FONTS', 'VFFONTS', 'TTFONTS']:
        try:
            os.environ[varName] = fontPath + os.environ[varName]
        except:
            os.environ[varName] = fontPath

    # -----------------------------------------------------------

    # initialise Global
    Global = Global

    # Initialize clean file data
    clean=CleanFile(clean_file)


    # Parsing options
    arg_parser = argparse.ArgumentParser(description="Enjoy the cool scons building tool!")
    arg_parser.add_argument('-c', '--clean', action='store_true', dest='clean', default=False, help='clean unversioned documents')
    arg_parser.add_argument('-t', '--thorough', action='store_true', dest='thorough', default=False, help='build missing files even when sources have not changed')
    arg_parser.add_argument('-j', '--multithread', action='store', dest='no_of_processes', type=int, default=1, help='create multiple build processes')
    arg_parser.add_argument('-r', '--repo', action='store_true', dest='repo', default=False, help='check if all necessary files were added in repository. Ignores in the subsequent build run SConscript_local-files')
    arg_parser.add_argument('-i', '--ignore-local', action='store_true', dest='ignore_local', default=False, help='ignore local SConscript files')
    arg_parser.add_argument('-s', '--silent', action='store_true', dest='silent', default=False, help='Puts latex into silent mode. No output will be shown and no errors as well. Only a list at the end which file was not successful.')

    arguments = arg_parser.parse_args()


    if arguments.clean:
      n=0

      for d in clean.clean_paths | set([buf_file, clean_file]):
        if os.path.exists(d):
          print('Remove: '+d)
          clean.del_file(d)
          n+=1

      print('scons: '+str(n)+' file(s) successfully removed.')
      print('scons: Done.')
      sys.exit()

    # Execute SConscript files
    print('scons: Reading SConscript files...')
    SConscript(scripts)

    # --------------------------------------------------------------------
    # Set elements: (path, file_data)
    # sub: tex/cls/sty or any other latex source file that is not compiled
    # --------------------------------------------------------------------

    # Buffer file
    if os.path.exists(buf_file):
      f=open(buf_file, 'rb')
      try:
        #try to load buffer files
        buf=pickle.load(f)
      except:
        # in case it is not working: create a new buffer
        buf=Buffer()
      finally:
        f.close()

      if buf.version!=version:
        # If the version has changed a new buffer file will be created deleting the old information
        print('scons: Version upgrade to '+str(version)+'.')
        buf=Buffer()
      else:
        print('scons: Using buffer file...')
    else:
      # in case there is no buffer file: create a new buffer
      buf=Buffer()

    buf.tex_dif=set(buf.tex.values()).difference(Global.tex)
    Global.tex.difference_update(set(buf.tex.values()).difference(buf.tex_dif))


    for path in buf.sub:
      if os.path.exists(path):
        if not buf.sub[path].update_checksum():
          FileDataTEX.changed_sub.add(path)
      else:
        FileDataTEX.check_sub.add(path)

    for data in Global.tex:
      path=data.path

      FileDataTEX.compilation.add(path)

      if path not in buf.tex:
        buf.tex[path]=data
      buf.tex[path].checksum = 0 # set checksum to zero if addedd to buffer
      #else:
      #  buf.tex[path].checksum=data.checksum

      FileDataTEX.changed_sub.update(buf.tex[path].update(buf.svg, buf.sub))


    for data in buf.tex_dif:
      path=data.path

      if path not in FileDataTEX.compilation:
        buf.tex[path].clear(buf.svg, buf.sub)

        del buf.tex[path]


    sub_parse=FileDataTEX.changed_sub.copy()

    while len(sub_parse)>0:
      path=sub_parse.pop()

      added_sub=buf.sub[path].update(buf.svg, buf.sub)
      sub_parse.update(added_sub)
      FileDataTEX.changed_sub.update(added_sub)


    while len(FileDataTEX.check_sub)>0:
      path=FileDataTEX.check_sub.pop()

      if len(buf.sub[path].parents)==0:
        buf.sub[path].clear(buf.svg, buf.sub)
        del buf.sub[path]
        FileDataTEX.changed_sub.discard(path)


    for path in FileDataSVG.check:
      if len(buf.svg[path].imported_in)+len(buf.svg[path].included_in)==0:
        if path not in Global.install:
          del buf.svg[path]
          FileDataSVG.compilation.discard(path)


    for path in buf.svg:
      if os.path.exists(path):
        if not buf.svg[path].update_checksum():
          FileDataSVG.compilation.add(path)
      else:
        FileDataSVG.check.add(path)


    # Update svg buffer (install path)
    for path in Global.install:
      if path.endswith('.svg'):
        if path not in buf.svg:
          buf.svg[path]=FileDataSVG(path)
          FileDataSVG.compilation.add(path)


    for path in FileDataSVG.compilation:
      FileDataTEX.changed_sub.update(buf.svg[path].imported_in)
      FileDataTEX.changed_sub.update(buf.svg[path].included_in)


    while len(FileDataTEX.changed_sub)>0:
      path=FileDataTEX.changed_sub.pop()

      if path in buf.tex:
        FileDataTEX.compilation.add(path)
      else:
        FileDataTEX.changed_sub.update(buf.sub[path].parents)


    # Check whether built files exist
    if arguments.thorough:
      for path in buf.tex:

        if not os.path.exists(path[0:-4]+'.pdf'):
          FileDataTEX.compilation.add(path)

        if path in Global.install:
          if not os.path.exists(os.path.join(Global.install[path], os.path.basename(path[0:-4]+'.pdf'))):
            FileDataTEX.compilation.add(path)

      for path in buf.svg:
        suffix=['.pdf']

        if path in Global.install:
          if not os.path.exists(os.path.join(Global.install[path], os.path.basename(path[0:-4]+'.pdf'))):
            FileDataSVG.compilation.add(path)

        if len(buf.svg[path].imported_in)>0:
          suffix.append('.pdf_tex')

        for s in suffix:
          if not os.path.exists(path[0:-4]+s):
            FileDataSVG.compilation.add(path)


    # Check repository status
    if arguments.repo:
      unknown_files=set()
      unknown_folders=set()

      # alternative implementation:
      git_status = subprocess.Popen('git status --ignored', stdout=subprocess.PIPE, shell=True)
      git_status = str(git_status.stdout.read())
      for line in git_status.split('Untracked files')[-1].replace('\t','').splitlines()[3:]:
          if os.path.isdir(line):
            unknown_folders.add(line)
          else:
            # use replace in order to avoid crazy behavior with windows
            unknown_files.add(line.replace('\\', '/'))

      needed_files=set([src_file.path for src_file in list(buf.tex.values()) + list(buf.svg.values()) + list(buf.sub.values())]) | Global.script_paths

      missing_files=unknown_files & needed_files
      missing_folders=set()

      for folder in unknown_folders:
        for needed_file in needed_files:
          if needed_file.find(folder)==0:
            missing_folders.add(folder)

      if len(missing_folders)+len(missing_files) != 0:
        red('scons: Not all necessary files were added in Subversion.')

      for folder in missing_folders:
        red('scons: Folder not added in Repository: '+folder)

      for f in missing_files:
        red('scons: File not added in Repository: '+f)

      if len(missing_folders)+len(missing_files) == 0:
        blue('scons: Congratulations! All necessary files were added in the Repository.')

      sys.exit()

    # Compilation
    print('scons: Start Compilation...')

    '''
    Update clean file data
    '''
    for path in FileDataSVG.compilation:
      clean.add(path[0:-4]+'.pdf')

      if len(buf.svg[path].imported_in)>0:
        clean.add(path[0:-4]+'.pdf_tex')

    for path in FileDataTEX.compilation:
      clean.add_tex(path)

    for path in Global.install:
      clean.add(os.path.join(Global.install[path], os.path.basename(path)[0:-4]+'.pdf'))

    clean.dump()

    '''
    Compile the files
    '''
    if arguments.no_of_processes<2:
      # Single-processing
      for path in FileDataSVG.compilation:
          compile_svg(path)

      # write to buffer file at least that the svg have been successful
      write_buffer(buf_file, buf, version)

      for path in FileDataTEX.compilation:
        (origpath ,checksum) = compile_tex(path)
        if checksum != 0:
            buf.tex[path].checksum = checksum
            install_tex(origpath)

    else:
      # Multi-processing

      # First SVGs
      pool=Pool(processes=arguments.no_of_processes)
      pool.map(compile_svg, FileDataSVG.compilation)
      pool.close()
      write_buffer(buf_file, buf, version) # write to buffer file at least that the svg have been successful

      # Then Latex-files
      pool=Pool(processes=arguments.no_of_processes)
      results = pool.map(compile_tex, FileDataTEX.compilation)
      pool.close()

      # not in parallel: save the result!
      for (path, checksum) in results:
          if checksum != 0:
              buf.tex[path].checksum = checksum
              install_tex(path)



    # Install files
    for path in Global.install:
      inst=False

      # check which file should be installed
      if path not in (FileDataSVG.compilation | FileDataTEX.compilation):
        if path not in buf.install:
          inst=True
        elif buf.install[path]!=Global.install[path]:
          inst=True

      if inst==True:
        install_path=Global.install[path]
        prepare_install(install_path)
        print('Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))
        shutil.copyfile(path[0:-4]+'.pdf', os.path.join(install_path, os.path.basename(path)[0:-4]+'.pdf'))

        buf.install=Global.install

    # Save buffer file
    write_buffer(buf_file, buf, version)



    print('scons: Finished compilation ('+str(len(FileDataSVG.compilation))+' Inkscape files, '+str(len(FileDataTEX.compilation)-len(FileDataTEX.tex_failed))+' LaTeX files).')
    if len(FileDataTEX.tex_failed)!=0:
      print('scons: Compilation of '+str(len(FileDataTEX.tex_failed))+' LaTeX files failed:')
      print(red('  -' + '\n  -'.join(FileDataTEX.tex_failed)))

    print('scons: Done.')
