#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, argparse, re
from tools_scons.filedata import FileDataTEX, FileDataSVG
from tools_scons.tools import *

os.chdir(os.path.dirname(os.path.abspath(__file__)))

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

  # START OF the script

if __name__ == '__main__': #For windows-parallelization this is needed

    # -----------------SETTINGS-------------------------
    version=0.1
    buf_file='.buffer'
    clean_file='.clean'

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


    print('scons: Done.')
