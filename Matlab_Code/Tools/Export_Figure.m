addpath('./Matlab2Tikz');

Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
% [fpathstr,fname,fext] = fileparts(which(mfilename));

%cleanfigure;
matlab2tikz('tikzFileComment',['%%% Johannes Maierhofer -', Datum, ' %%%'],'height','\fheight','width','\fwidth','filename',[Datum, '.tikz']);
