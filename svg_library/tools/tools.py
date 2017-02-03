from __future__ import print_function, with_statement
import os, sys, re, subprocess, hashlib


# -----------------SETTINGS-------------------------
sty_lib_path='.'#'lib/Tools'
cls_lib_path='.'#'lib/Klassen'
# --------------------------------------------------


platform=sys.platform


def platform_path(path):
  if platform == 'win32':
    return path.replace('/', '\\')
  else:
    return path


sty_lib_path=platform_path(sty_lib_path)
cls_lib_path=platform_path(cls_lib_path)


def red(msg):
  print('\033[1;31m'+msg+'\033[1;m')


def blue(msg):
  print('\033[1;34m'+msg+'\033[1;m')


def settostr(set_):
  scp=set_.copy()
  string=scp.pop()
  while len(scp)!=0:
    string=string+', '+scp.pop()
  return string


def listdf(dirname):
  dirs=[]
  files=[]

  for f in os.listdir(dirname):
    if f.find('.')==0:
      continue

    f=os.path.join(dirname, f)

    if os.path.isdir(f):
      dirs.append(f)
    elif os.path.isfile(f):
      files.append(f)

  return dirs, files


def timestamp(path):
  return int(10.0*os.path.getmtime(path))


def checksum(path):
  """
  Calculates the checksum of a file
  """
  checksum=hashlib.md5()
  fh=open(path, 'rb')
  while True:
    buf=fh.read(4096)
    if not buf : break
    checksum.update(buf)
  fh.close()

  return checksum.hexdigest()


def sf(endswith, directory, maxdepth):
  #Returns the paths relative to the current directory to all files with
  #the following characteristics:
  #
  #1) The filename ends with the characters specified by the optional
  #   keyword endswith.
  #2) The file is found in the directory specified by the keyword
  #   directory or in the subfolders of that directory, if keyword
  #   maxdepth is greater than 1. For maxdepth=2, the subfolders are
  #   also searched, for maxdepth=3, the subfolders of the subfolders
  #   are also searched, etc.

  scan_files=[]
  scan_dirs=set([(directory, 1)])

  while len(scan_dirs)!=0:
    d, depth=scan_dirs.pop()

    dirs, files=listdf(d)

    for f in files:
      if f.endswith(endswith):
        scan_files.append(os.path.relpath(f, directory))

    if depth<maxdepth:
      for d in dirs:
        scan_dirs.add((d, depth+1))

  return scan_files


sty_lib=[os.path.join(sty_lib_path, s) for s in sf(endswith='.sty', directory=sty_lib_path, maxdepth=1)]
cls_lib=[os.path.join(cls_lib_path, s) for s in sf(endswith='.cls', directory=cls_lib_path, maxdepth=1)]


def parse(path):
  with open(path, 'rb') as f:
      data = f.read().decode('utf8', 'ignore')
#  f=open(path)
#  data=f.read()
#  f.close()


  # Comment removal
  re_com=re.compile(r'%(?!SCONS_IGNORE)[^\n]*')
  data=re_com.sub('', data)


  re_sty=re.compile(r'\\usepackage(?:\[.*?\])?{(.+?)}', re.MULTILINE)
  re_inc=re.compile(r'\\include{(.+?)}', re.MULTILINE)
  re_inp=re.compile(r'\\input{(.+?)}', re.MULTILINE)
  re_doc=re.compile(r'\\documentclass(?:\[.*?\])?{(.+?)}', re.MULTILINE)
  re_igr = re.compile(r'\\includegraphics(?:\[.*?\])?{(.+?)}(?!%SCONS_IGNORE)',re.MULTILINE)
  re_titlepages = re.compile(r'\\titlepicture{(.+?)}',re.MULTILINE)
  re_imp=re.compile(r'\\import{(.*?)}{(.+?)}', re.MULTILINE)


  imported_svg=set()
  included_svg=set()
  included_pdf=set()
  included_sub=set()


  # Files that are included via \input or \include
  for tex in re_inc.findall(data)+re_inp.findall(data):
    if not os.path.exists(tex):
      if os.path.exists(tex+'.tex'):
        tex=tex+'.tex'
      else:
        red('\nFile not found: '+tex)
        red('Needed by file: '+path+'\n')
        raise Exception

    included_sub.add(tex)


  # Files that are included via \includegraphics
  for pdf in re_igr.findall(data):
    if pdf.endswith('.pdf'):
      pdf=pdf[0:-4]

    if os.path.exists(pdf+'.svg'):
      included_svg.add(pdf+'.svg')
    elif os.path.exists(pdf+'.pdf'):
      included_pdf.add(pdf+'.pdf')
    else:
        if not '@titlepicture' in pdf:
          red('\nFile not found: '+pdf+'.svg')
          red('Needed by file: '+path+'\n')
          raise Exception

  for pdf in re_titlepages.findall(data):
    if pdf.endswith('.pdf'):
      pdf=pdf[0:-4]

    if os.path.exists(pdf+'.svg'):
      included_svg.add(pdf+'.svg')
    elif os.path.exists(pdf+'.pdf'):
      included_pdf.add(pdf+'.pdf')
    else:
      red('\nFile not found: '+pdf+'.svg')
      red('Needed by file: '+path+'\n')
      raise Exception


  # Files that are included via \import
  for pdf_tex in re_imp.findall(data):
    pdf_tex=os.path.join(pdf_tex[0], pdf_tex[1])

    if not(pdf_tex.endswith('.pdf_tex')):
      red('\nFile extension of imported files must be "'+'.pdf_tex".')
      red('File: '+pdf_tex)
      red('Imported in file: '+path+'\n')
      raise Exception

    if os.path.exists(pdf_tex[:-8] + '.svg'):
      imported_svg.add(pdf_tex[:-8] + '.svg')
    else:
      red('\nFile not found: '+pdf_tex[0:-8]+'.svg')
      red('Needed by file: '+path+'\n')
      raise Exception


  # Class files
  #for cls in re_doc.findall(data):
  #
  #  cls=platform_path(cls)
  #
  #  if cls.find(cls_lib_path)==0:
  #    if not cls.endswith('.cls'):
  #      cls=cls+'.cls'
  #
  #    if cls in cls_lib:
  #      included_sub.add(cls)
  #    else:
  #      print cls_lib
  #
  #      red('\nFile not found: '+cls)
  #      red('Needed by file: '+path+'\n')
  #      raise Exception


  # Style files
  #for sty in re_sty.findall(data):
  #  if sty.find(sty_lib_path)==0:
  #    if not sty.endswith('.sty'):
  #      sty=sty+'.sty'
  #
  #    if sty in sty_lib:
  #      included_sub.add(sty)
  #    else:
  #      red('\nFile not found: '+sty)
  #      red('Needed by file: '+path+'\n')
  #      raise Exception

  return imported_svg, included_svg, included_pdf, included_sub


class CleanFile:
    '''
    Class to remove the files in a directory with the given "endings"
    '''
    tex_clean=['.aux', '.log', '.idx', '.toc', '.out', '.nav', '.snm', '.bcf',
               '.blg','.bbl', '.lof', '.run.xml']


    def __init__(self, filename):
        self.filename=filename

        if os.path.exists(filename):
            self.f=open(filename, 'r')
            data=self.f.read()
            self.f.close()
            self.clean_paths=set(data.splitlines())
        else:
            self.clean_paths=set()

    def del_file(self, path):
        if os.path.exists(path):
            os.remove(path)

    def dump(self):
        self.f=open(self.filename, 'w')

        for path in self.clean_paths:
            self.f.write(path+'\n')

        self.f.close()

    def add(self, path):
        self.clean_paths.add(path)

    def add_tex(self, path):
        for t in CleanFile.tex_clean+['.pdf']:
            self.add(path[0:-4]+t)

    def clean_tex(self, path):
        for t in CleanFile.tex_clean:
            self.del_file(path[0:-4]+t)
