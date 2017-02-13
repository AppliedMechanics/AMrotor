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
