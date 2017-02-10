#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, subprocess, shutil, argparse, re
import jinja2

# latex_jinja_env = jinja2.Environment(
#     block_start_string = '\BLOCK{',
#     block_end_string = '}',
#     variable_start_string = '\VAR{',
#     variable_end_string = '}',
#     comment_start_string = '\#{',
#     comment_end_string = '}',
#     line_statement_prefix = '%-',
#     line_comment_prefix = '%#',
#     trim_blocks = True,
#     autoescape = False,
#     loader = jinja2.FileSystemLoader(os.path.abspath('.'))
# )
# template = latex_jinja_env.get_template('templates/jinja-test.text')
# template.render(inputfile=)

os.chdir(os.path.dirname(os.path.abspath(__file__)))

#main configuration
#------------------
#output specification
output_suffix = "_cv"
create_emf_file = False
create_eps_file = False
create_svg_file = False
create_png_file = True
create_pdf_file = False
create_pdf2_file = False

folder_pure_svgs = ['pure_svg']
folder_tex_svgs = ['tex_svg']
folder_install = 'build/'

output_width = 640
output_height = 640
##

	#get list of files in current directory (don't look into subdirectories)
#AllFiles = filter(os.path.isfile,os.listdir(os.curdir+'/pure_svg'))

AllFiles=dir()

for root, dirs, files in os.walk('.'):
    for file in files:
        AllFiles.append(os.path.join(root,file))

#filter .svg files and avoid double-conversion
InputFiles = []
for File in AllFiles:
    print(File)
    Extension = os.path.splitext(os.path.basename(File))[1]
    if (Extension.lower() == ".svg") and File.find(output_suffix) == -1:
        InputFiles.append(File)

for InputFile in InputFiles:
    #extract base file name (without path and extension) and extension
    BaseFileName = os.path.splitext(os.path.basename(InputFile))[0]
    Extension = os.path.splitext(os.path.basename(InputFile))[1]

    #set output filenames
    OutputFileNames = folder_install + BaseFileName + output_suffix

    #define output file names
    LatexFile_wo_ext = OutputFileNames
    PDFFile = OutputFileNames + ".pdf"
    SVGFile = OutputFileNames + ".svg"
    PNGFile = OutputFileNames + ".png"
    EMFFile = OutputFileNames + ".emf"
    EPSFile = OutputFileNames + ".eps"

    if Extension.lower() == ".svg":
        print ("Converting " + BaseFileName + Extension + " (SVG-file)...")

        try:
            if create_png_file == True:
              cmd = "inkscape"+" --file=" + InputFile+" --export-png=" + PNGFile + ' --export-width=' + str(output_width) + ' --export-height=' + str(output_height)
              print('Compile:' + cmd)
              sys_out = os.system(cmd)

            if create_emf_file == True:
              cmd = "inkscape"+" --file=" + InputFile+" --export-emf=" + EMFFile
              print('Compile:' + cmd)
              sys_out = os.system(cmd)

            if create_eps_file == True:
              cmd = "inkscape"+" --file=" + InputFile+" --export-eps=" + EPSFile
              print('Compile:' + cmd)
              sys_out = os.system(cmd)

            if create_pdf_file == True:
              cmd = "inkscape"+" --file=" + InputFile+" --export-pdf=" + PDFFile
              print('Compile:' + cmd)
              sys_out = os.system(cmd)

            if create_pdf2_file == True:
                  #create version of pdf with paths instead of text (via ghostscript)
              if call(["gs","-o" + PDFFile,"-dNoOutputFonts","-sDEVICE=pdfwrite","-dQUIET",PDFFile]) != 0:
                  sys.exit("Error: ghostscript threw an error! (while converting the fonts of the pdf to paths)")

        except subprocess.CalledProcessError as grepexc:
          print("error code", grepexc.returncode, grepexc.output)
          sys.exit(10)

        print("Conversion pure svgs Done!")

    #unknown file type
    else:
        print("Unknown filetype of " + BaseFileName + Extension + " (has to be .svg) -> ignoring this file")
