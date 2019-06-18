function tikzFigures(obj,figureHandle,prefix)

%addpath('./private/Matlab2Tikz');

obj.checkAndCreateFolder(obj.outputFigureFolder);
figureNameWithoutSpaces = strrep(figureHandle.Name,' ','_');
fileName = strcat('./',obj.outputFigureFolder,'/',...
                        prefix,'_',figureNameWithoutSpaces);

%cleanfigure;
matlab2tikz('tikzFileComment',['%%% Johannes Maierhofer - AMrotor %%%'],'height','\fheight','width','\fwidth','filename',[fileName, '.tikz']);


end