#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, subprocess, shutil, argparse, re
import jinja2

latex_jinja_env = jinja2.Environment(
     block_start_string = '\BLOCK{',
     block_end_string = '}',
     variable_start_string = '\VAR{',
     variable_end_string = '}',
     comment_start_string = '\#{',
     comment_end_string = '}',
     line_statement_prefix = '%-',
     line_comment_prefix = '%#',
     trim_blocks = True,
     autoescape = False,
     loader = jinja2.FileSystemLoader(os.path.abspath('.'))
)
template = latex_jinja_env.get_template('tools/templates/pdf_tex2pdf.tex')


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

output_width = 1280
output_height = 640
##

###############################################################################
# Parsing options
arg_parser = argparse.ArgumentParser(description="Enjoy the cool scons building tool!")
arg_parser.add_argument('-c', '--clean', action='store_true', dest='clean', default=False, help='clean unversioned documents')
arg_parser.add_argument('-s', '--silent', action='store_true', dest='silent', default=False, help='Puts latex into silent mode. No output will be shown and no errors as well. Only a list at the end which file was not successful.')

arg_parser.add_argument('-p', '--pure', action='store_true', dest='pure', default=False, help='Builds only the pure svgs')
arg_parser.add_argument('-t', '--tex', action='store_true', dest='tex', default=False, help='Build only the tex svgs')

arguments = arg_parser.parse_args()



###############################################################################
# Handle pure svgs
###############################################################################
if arguments.pure:
    AllFiles=dir()

    for pure_svg_folder in folder_pure_svgs:
        for root, dirs, files in os.walk('./'+pure_svg_folder):
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
                  cmd = "inkscape"+" --file=" + InputFile+" --export-png=" + PNGFile + ' --export-width=' + str(output_width)# + ' --export-height=' + str(output_height)
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

###############################################################################
# Handle tex_svgs
###############################################################################

if arguments.tex:
    AllFiles=dir()

    for tex_svg_folder in folder_tex_svgs:
        for root, dirs, files in os.walk('./'+tex_svg_folder):
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

        PDFtexFile = 'tex_svg/' + BaseFileName + '_tex.pdf'
        LatexFile = 'tex_svg/' + BaseFileName + '.tex'
        LatexFile_wo_ext = 'tex_svg/' + BaseFileName
        PDFFilePaths = 'tex_svg/prebuild/' + BaseFileName + '.pdf'
        #define output file names

        PDFFile = OutputFileNames + ".pdf"
        SVGFile = OutputFileNames + ".svg"
        PNGFile = OutputFileNames + ".png"
        EMFFile = OutputFileNames + ".emf"
        EPSFile = OutputFileNames + ".eps"

        if Extension.lower() == ".svg":
            print ("Converting " + BaseFileName + Extension + " (SVG-file)...")

            try:
              cmd = "inkscape"+" --file=" + InputFile + " --export-pdf=" + PDFtexFile + " --export-latex"
              print('Compile:' + cmd)
              sys_out = os.system(cmd)


              with open(LatexFile,'w+') as f:
                f.write(template.render(inputfile=PDFtexFile+'_tex'))

              cmd="pdflatex" + " -interaction=batchmode " + LatexFile + " -output-directory="  + folder_tex_svgs[0]
              print('LaTeX-Compile:' + cmd)
              sys_out = os.system(cmd)

              cmd="gs"+" -o " + PDFFilePaths+" -dNoOutputFonts"+" -sDEVICE=pdfwrite"+" -dQUIET " + LatexFile_wo_ext+'.pdf'
              print('Ghostscript:' + cmd)
              sys_out = os.system(cmd)

              if create_svg_file == True:
                cmd = "inkscape"+" --file=" + PDFFilePaths + " --export-plain-svg=" + SVGFile
                print('Compile:' + cmd)
                sys_out = os.system(out)

              if create_png_file == True:
                cmd = "inkscape"+" --file=" + PDFFilePaths +" --export-png=" + PNGFile + ' --export-width=' + str(output_width) # + ' --export-height=' + str(output_height)
                print('Compile:' + cmd)
                sys_out = os.system(cmd)

              if create_emf_file == True:
                cmd = "inkscape"+" --file=" + PDFFilePaths +" --export-emf=" + EMFFile
                print('Compile:' + cmd)
                sys_out = os.system(cmd)

              if create_eps_file == True:
                cmd = "inkscape"+" --file=" + PDFFilePaths +" --export-eps=" + EPSFile
                print('Compile:' + cmd)
                sys_out = os.system(cmd)


            except subprocess.CalledProcessError as grepexc:
              print("error code", grepexc.returncode, grepexc.output)
              sys.exit(10)

            print("Conversion tex svgs Done!")

        	#remove helper files
            os.remove(LatexFile)
            os.remove(PDFtexFile)
            os.remove(LatexFile_wo_ext + ".aux")
            os.remove(LatexFile_wo_ext + ".log")

        #unknown file type
        else:
            print("Unknown filetype of " + BaseFileName + Extension + " (has to be .svg) -> ignoring this file")

###############################################################################
# clean up
###############################################################################
if arguments.clean:
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith(".aux"):
                os.remove(os.path.join(file))
            if file.endswith(".log"):
                os.remove(os.path.join(file))

    print('Aufräumen erfolgreich ;-)')
