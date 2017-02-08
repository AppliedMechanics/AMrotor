#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, argparse, re
from tools_scons.filedata import FileDataTEX, FileDataSVG
from tools_scons.tools import *

os.chdir(os.path.dirname(os.path.abspath(__file__)))
base_dir = os.path.abspath(__file__)

def rasterize_svg(path):
  '''
  Compilation of the svg file given in path
  '''

  output_width = 640
  output_height = 640

  buf.svg[path].check_consistency(Global.install)

  try:

      cmd = 'inkscape -z -D --export-png=' + \
            os.path.join(Global.base_dir, path)[0:-4] + '.png --file=' + \
            os.path.join(Global.base_dir, path) + ' --export-width=' + output_width + ' --export-height=' + output_height \
      print('Compile:' + cmd)
      sys_out = os.system(cmd)

  except subprocess.CalledProcessError as grepexc:
      print("error code", grepexc.returncode, grepexc.output)
      sys.exit(10)

  if path in Global.install:
      install_path=Global.install[path]
      prepare_install(install_path)
      print('Install: '+os.path.join(install_path, os.path.basename(path)[0:-4]+'.png'))
      shutil.copyfile(path[0:-4]+'.png', os.path.join(install_path, os.path.basename(path)[0:-4]+'.png'))

  return sys_out


def prepare_install(path):
  if not os.path.isdir(path):
    os.makedirs(path)


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


  # START OF the script

if __name__ == '__main__': #For windows-parallelization this is needed

    # -----------------SETTINGS-------------------------
    version=0.1
    scripts=['SConscript']
    # -----------------------------------------------------------
    print('Hello to the svg-library compiler')

    # Parsing options
    arg_parser = argparse.ArgumentParser(description="Enjoy the cool building tool!")
    arg_parser.add_argument('-c', '--clean', action='store_true', dest='clean', default=False, help='clean unversioned documents')
#    arg_parser.add_argument('-t', '--thorough', action='store_true', dest='thorough', default=False, help='build missing files even when sources have not changed')
#    arg_parser.add_argument('-r', '--repo', action='store_true', dest='repo', default=False, help='check if all necessary files were added in repository. Ignores in the subsequent build run SConscript_local-files')
#    arg_parser.add_argument('-i', '--ignore-local', action='store_true', dest='ignore_local', default=False, help='ignore local SConscript files')
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

    print('Done.')
