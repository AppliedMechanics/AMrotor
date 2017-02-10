#import libraries
import os
import sys
import shutil
from subprocess import call
from pyPdf import PdfFileReader

#main configuration
#------------------
#output specification
output_suffix = "_converted"
create_emf_file = True
create_eps_file = False
create_svg_file = False
create_png_file = True
create_pdf_file = False
create_pdf_tex_file = False

#latex template
documentclass = "\\documentclass[11pt,ngerman,fleqn]{article}"
encoding = "\\usepackage[utf8]{inputenc}"
latexheader = []
latexheader.append("\\usepackage{graphicx}")
latexheader.append("\\usepackage{color}")
latexheader.append("\\setlength\\parindent{0pt}")
latexheader.append("\\usepackage{nopageno}")
latexheader.append("\\usepackage{AMcolor}")
latexheader.append("\\usepackage[theme=tumhelvetica]{AMfont}")
latexheader.append("\\usepackage{AMgraphic}")
latexheader.append("\\usepackage{AMlang}")
latexheader.append("\\usepackage{AMmath}")
latexheader.append("\\usepackage{AMtikz}")
latexheader.append("\\usepackage{AMutils}")
latexheader.append("\\AMsetFont{math=latex}")

#conversion
#----------
#get list of input files
if len(sys.argv) <= 1:
	#no filelist was given -> convert all files in the current folder
	
	#get list of files in current directory (don't look into subdirectories)
	AllFiles = filter(os.path.isfile,os.listdir(os.curdir))
	
	#filter .tex and .svg files and avoid double-conversion
	InputFiles = []
	for File in AllFiles:
		Extension = os.path.splitext(os.path.basename(File))[1]
		if (Extension.lower() == ".tex" or Extension.lower() == ".svg") and File.find(output_suffix) == -1:
			InputFiles.append(File)
else:
	#the user gave us a file list
	InputFiles = sys.argv[1:]

#loop through all given input files
#----------------------------------
for InputFile in InputFiles:
	#extract base file name (without path and extension) and extension
	BaseFileName = os.path.splitext(os.path.basename(InputFile))[0]
	Extension = os.path.splitext(os.path.basename(InputFile))[1]

	#set output filenames
	OutputFileNames = BaseFileName + output_suffix

	#define output file names
	LatexFile_wo_ext = OutputFileNames
	LatexFile = LatexFile_wo_ext + ".tex"
	PDFFile = OutputFileNames + ".pdf"
	PDFtexFile = OutputFileNames + "_latex.pdf"
	PDFFilePaths = OutputFileNames + "_paths.pdf"
	SVGFile = OutputFileNames + ".svg"
	PNGFile = OutputFileNames + ".png"
	EMFFile = OutputFileNames + ".emf"
	EPSFile = OutputFileNames + ".eps"
	BBoxFile = OutputFileNames + "_bbox.txt"

	#conversion of tex files
	if Extension.lower() == ".tex":
		print "Converting " + BaseFileName + Extension + " (tex-file)..."

		#write latex file (first iteration)
		latexfile = open(LatexFile,"w")
		latexfile.write(documentclass + "\n")
		latexfile.write(encoding + "\n")
		latexfile.write("\\usepackage[paperwidth=1000mm,paperheight=1000mm,margin=0mm]{geometry}")
		for latexheaderline in latexheader:
			latexfile.write(latexheaderline + "\n")
		latexfile.write("\\begin{document}\n")
		latexfile.write("\\setlength{\\mathindent}{0mm}\n")
		latexfile.write("\\input{" + BaseFileName + "}\n")
		latexfile.write("\\end{document}\n")
		latexfile.close()

		#compile with pdflatex
		devnull = open(os.devnull,'w')
		if call(["pdflatex","-interaction=batchmode",LatexFile],stdout=devnull,stderr=devnull) != 0:
			sys.exit("Error: pdflatex threw an error! (in first iteration)")

		#get bounding box dimensions
		bboxfile = open(BBoxFile,'w')
		if call(["gs","-q","-dBATCH","-dNOPAUSE","-sDEVICE=bbox",PDFFile],stdout=bboxfile,stderr=bboxfile) != 0:
			sys.exit("Error: ghostscript threw an error! (while computing bounding-box)")
		bboxfile.close()
		compare_str="%%HiResBoundingBox:"
		with open(BBoxFile) as bbox_in:
	    		bbox_in_lines = bbox_in.readlines()
			for j in range(0,len(bbox_in_lines)):
				curLine = str(bbox_in_lines[j])
				if curLine[0:len(compare_str)] == compare_str:
					curLineParts = curLine.split(' ')
	
		#compute size in mm
		eq_width_mm = (float(curLineParts[3])-float(curLineParts[1]))/71.0*25.4	
		eq_height_mm = (float(curLineParts[4])-float(curLineParts[2]))/71.0*25.4	

		#write latex file (second iteration)
		latexfile = open(LatexFile,"w")
		latexfile.write(documentclass + "\n")
		latexfile.write(encoding + "\n")
		latexfile.write("\\usepackage[paperwidth=" + str(eq_width_mm+10) + "mm,paperheight=" + str(eq_height_mm+10) + "mm,margin=4mm]{geometry}")
		for latexheaderline in latexheader:
			latexfile.write(latexheaderline + "\n")
		latexfile.write("\\begin{document}\n")
		latexfile.write("\\setlength{\\mathindent}{0mm}\n")
		latexfile.write("\\input{" + BaseFileName + "}")
		latexfile.write("\\end{document}\n")
		latexfile.close()

		#compile with pdflatex
		devnull = open(os.devnull,'w')
		if call(["pdflatex","-interaction=batchmode",LatexFile],stdout=devnull,stderr=devnull) != 0:
			sys.exit("Error: pdflatex threw an error! (in second iteration)")
	
		#create version of pdf with paths instead of text (via ghostscript)
		if call(["gs","-o" + PDFFilePaths,"-dNoOutputFonts","-sDEVICE=pdfwrite","-dQUIET",PDFFile]) != 0:
			sys.exit("Error: ghostscript threw an error! (while converting the fonts of the pdf to paths)")
	 
		#create converted SVG, EMF and EPS files
		if create_svg_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-plain-svg=" + SVGFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to svg)")
		if create_emf_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-emf=" + EMFFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to emf)")
		if create_eps_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-eps=" + EPSFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to eps)")
		if create_png_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-png=" + PNGFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to png)")

		#remove helper files
		os.remove(LatexFile)
		os.remove(LatexFile_wo_ext + ".aux")
		os.remove(LatexFile_wo_ext + ".log")
		os.remove(PDFFilePaths)
		os.remove(BBoxFile)
		if create_pdf_file == False:
			os.remove(PDFFile)
			
		print "Done!"

	#conversion of SVG files
	elif Extension.lower() == ".svg":
		print "Converting " + BaseFileName + Extension + " (SVG-file)..."

		#export inputfile to pdf + pdf_tex via inkscape
		if call(["inkscape","--file=" + InputFile,"--export-pdf=" + PDFtexFile,"--export-latex"]) != 0:
			sys.exit("Error: inkscape threw an error! (while exporting to pdf_tex)")

		#get PDF information
		pdfInfo = PdfFileReader(file(PDFtexFile))
		pdfSize_pt = pdfInfo.getPage(0).mediaBox
		pdfWidth_mm = round(float(pdfSize_pt[2])/72.0*25.4,1)
		pdfHeight_mm = round(float(pdfSize_pt[3])/72.0*25.4,1)
		pdfPageCount = pdfInfo.getNumPages() 

		#avoid inkscape error (multipage export)
		os.rename(PDFtexFile+"_tex",PDFtexFile+"_texori")
		compare_left_str="\\put(0,0){\\includegraphics[width=\\unitlength,page="
		compare_right_str="]{"
		with open(PDFtexFile+"_texori") as ftex_in:
	    		ftex_in_lines = ftex_in.readlines()
			ftex_out = open(PDFtexFile+"_tex","w")
			for j in range(0,len(ftex_in_lines)):
				curLine = str(ftex_in_lines[j])
				start_idx = curLine.find(compare_left_str)
				if start_idx == -1:
					ftex_out.write(curLine)
				else:
					start_idx = start_idx+len(compare_left_str)
					end_idx = curLine.find(compare_right_str)
					if end_idx == -1:
						ftex_out.write(curLine)
					else:
						page_number_str = curLine[start_idx:end_idx]
						page_number = int(page_number_str)
						if page_number <= pdfPageCount:
							ftex_out.write(curLine)				
			ftex_out.close()
		os.remove(PDFtexFile+"_texori")

		#write latex file
		latexfile = open(LatexFile,"w")
		latexfile.write(documentclass + "\n")
		latexfile.write(encoding + "\n")
		latexfile.write("\\usepackage[paperwidth=" + str(pdfWidth_mm+0.1) + "mm,paperheight=" + str(pdfHeight_mm+0.1) + "mm,margin=0mm]{geometry}")
		for latexheaderline in latexheader:
			latexfile.write(latexheaderline + "\n")
		latexfile.write("\\begin{document}\n")
		latexfile.write("\\input{" + PDFtexFile + "_tex}\n")
		latexfile.write("\\end{document}\n")
		latexfile.close()

		#compile with pdflatex
		devnull = open(os.devnull,'w')
		if call(["pdflatex","-interaction=batchmode",LatexFile],stdout=devnull, stderr=devnull) != 0:
			sys.exit("Error: pdflatex threw an error!")

		#create version of pdf with paths instead of text (via ghostscript)
		if call(["gs","-o" + PDFFilePaths,"-dNoOutputFonts","-sDEVICE=pdfwrite","-dQUIET",PDFFile]) != 0:
			sys.exit("Error: ghostscript threw an error! (while converting the fonts of the pdf to paths)")

		#create converted SVG, EMF and EPS files
		if create_svg_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-plain-svg=" + SVGFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to svg)")
		if create_emf_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-emf=" + EMFFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to emf)")
		if create_eps_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-eps=" + EPSFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to eps)")
		if create_png_file == True:
			if call(["inkscape","--file=" + PDFFilePaths,"--export-png=" + PNGFile]) != 0:
				sys.exit("Error: inkscape threw an error! (while exporting to png)")

		#remove helper files
		os.remove(LatexFile)
		os.remove(LatexFile_wo_ext + ".aux")
		os.remove(LatexFile_wo_ext + ".log")
		os.remove(PDFFilePaths)
		if create_pdf_file == False:
			os.remove(PDFFile)
		if create_pdf_tex_file == False:
			os.remove(PDFtexFile)
			os.remove(PDFtexFile + "_tex")

		print "Done!"

	#unknown file type
	else:
		print "Unknown filetype of " + BaseFileName + Extension + " (has to be .tex or .svg) -> ignoring this file"

