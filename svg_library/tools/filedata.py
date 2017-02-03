from __future__ import print_function, with_statement

from .tools import *

class FileData:
    def __init__(self, path):
        self.path = path
        self.checksum = self.calculate_checksum()

    def calculate_checksum(self):
        md5cs = hashlib.md5()
        fh = open(self.path, 'rb')
        while True:
            buf = fh.read(4096)
            if not buf : break
            md5cs.update(buf)
        fh.close()

        return md5cs.hexdigest()

    def update_checksum(self):
        old_checksum = self.checksum
        self.checksum = self.calculate_checksum()
    
        return self.checksum == old_checksum
    
    def __hash__(self):
        return hash((self.path, self.checksum))
    
    def __eq__(self, other):
        return (self.path, self.checksum) == other
    
    def __str__(self):
        return self.path
    
class FileDataTEX(FileData):
    compilation = set()
    check_sub = set()  # check for removal from sub dictionary
    changed_sub = set()  # changed files from sub dictionary
    tex_failed = []
    
    def __init__(self, path):
        FileData.__init__(self, path)
        
        self.imported_svg = set()
        self.included_svg = set()
        self.included_pdf = set()
        self.included_sub = set()
        
        self.parents = set()
    
    
    def clear(self, svg, sub):
        self.update(svg, sub, True)
    
    def update(self, svg, sub, clear=False):
    
        added_sub = set()
        
        if clear == True:
            imported_svg = set()
            included_svg = set()
            included_pdf = set()
            included_sub = set()
        else:
            imported_svg, included_svg, included_pdf, included_sub = parse(self.path)
        
        for added in imported_svg - self.imported_svg:
            self.imported_svg.add(added)
        
            if added not in svg:
                svg[added] = FileDataSVG(added)
        
            svg[added].add_imported_in(self.path)
        
        for removed in self.imported_svg - imported_svg:
            self.imported_svg.remove(removed)
            svg[removed].remove_parent(self.path)
        
        for added in included_svg - self.included_svg:
            self.included_svg.add(added)
        
            if added not in svg:
                svg[added] = FileDataSVG(added)
        
            svg[added].add_included_in(self.path)
        
        for removed in self.included_svg - included_svg:
            self.included_svg.remove(removed)
            svg[removed].remove_parent(self.path)
        
        for added in included_sub - self.included_sub:
            self.included_sub.add(added)
            
            if added not in sub:
                sub[added] = FileDataTEX(added)
                added_sub.add(added)
            
            sub[added].parents.add(self.path)
        
        for removed in self.included_sub - included_sub:
            self.included_sub.remove(removed)
            sub[removed].remove_parent(self.path)
        
        return added_sub
    
    def remove_parent(self, parent_path):
        self.parents.remove(parent_path)
        
        if len(self.parents) == 0:
            FileDataTEX.check_sub.add(self.path)
    
class FileDataSVG(FileData):
    compilation = set()
    check = set()
    
    def __init__(self, path):
        FileData.__init__(self, path)
        
        self.imported_in = set()
        self.included_in = set()
    
    def check_consistency(self, install):
        if len(self.imported_in) != 0:
            if len(self.included_in) != 0:
                red('\nInclusion error: ' + self.path)
                red('Simultaneous inclusion via \\import and \\'+
                    'includegraphics is not allowed.')
                red('\\import:          ' + settostr(self.imported_in))
                red('\\includegraphics: ' + settostr(self.included_in) + '\n')
                raise Exception
            
            if self.path in install:
                red('\nInstall error: ' + self.path)
                red('Inclusion via \\import and setting install folder is not allowed.')
                red('\\import:       ' + settostr(self.imported_in))
                red('Install folder: ' + install[self.path])
                raise Exception
    
    def remove_parent(self, parent_path):
        self.imported_in.discard(parent_path)
        self.included_in.discard(parent_path)
        
        if len(self.imported_in) + len(self.included_in) == 0:
            FileDataSVG.check.add(self.path)
    
    def add_imported_in(self, parent_path):
        self.imported_in.add(parent_path)
    
        if len(self.imported_in) == 1:
            FileDataSVG.compilation.add(self.path)
    
    def add_included_in(self, parent_path):
        self.included_in.add(parent_path)
    
        if len(self.included_in) == 1:
            FileDataSVG.compilation.add(self.path)
    