function outputFigures(obj,figureHandle,prefix,options)
%OUTPUTFIGURES Summary of this function goes here
% Figures fuer Diss speichern:
% die Figure wird als pdf-File im aktuellen Verzeichnis abgespeichert
%
% Input:
% filename     ... gewuenschter Name der figure (z.B.: 'Figure1')
% plotvariante ... plotvariante
%                    1 ... eine Figure
%                   11 ... eine Figure
%                   13 ... eine Figure breit
%                    2 ... zwei Figures in einer Zeile (subfigure in Latex)
%                   12 ... zwei Figures in einer Zeile (subplot in Matkab)
%                   21 ... zwei Figures in einer Spalte (subplot in Matlab)
%                   22 ... zwei Figures in einer Spalte (subplot in Matlab)
%                          und zwei Figures in einer Zeile (subfigure in Latex)
%                   31 ... drei Figures in einer Spalte (subplot in Matlab)
%                    8 ... Detail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% max Textberite: 15 cm
% max Texthoehe:  23 cm
plotvariante = 0;

switch length(options)
    case 1
        plotvariante = options(1);
    case 2
        xSize = options(1);
        ySize = options(2);
    otherwise
        error('Too many options are set for the PlotJanitor.outputFigures(...)');
end

switch plotvariante
    case {11,1}
        xSize = 10;  % Breite der figure [cm]
        ySize = 7.5; % Hoehe der figure [cm]
    case 13
        xSize = 12.5;  % Breite der figure [cm]
        ySize = 7.5; % Hoehe der figure [cm]
    case 2
        xSize = 7;   % Breite der figure [cm]
        ySize = 5.25; % Hoehe der figure [cm]
    case 12
        xSize = 15;   % Breite der figure [cm]
        ySize = 5.775; % Hoehe der figure [cm]
    case 21
        xSize = 10; % Breite der figure [cm]
        ySize = 15; % Hoehe der figure [cm]
    case 22
        xSize = 7; % Breite der figure [cm]
        ySize = 12; % Hoehe der figure [cm]
    case 31
        xSize = 12.5; % Breite der figure [cm]
        ySize = 22; % Hoehe der figure [cm]
    case 41
        xSize = 8;%7.5;%12.5; % Breite der figure [cm]
        ySize = 25; % Hoehe der figure [cm]
    case 8
        xSize = 7/2;   % Breite der figure [cm]
        ySize = 5.25/2; % Hoehe der figure [cm]
    case 10
        xSize = 18;   % Breite der figure [cm]
        ySize = 15; % Hoehe der figure [cm]
end

fontSizeAxis  = 8;  % Schriftgroesse Achsen (Zahlen)
fontTypeAxis  = 'Arial'; % Schriftart Achsen
fontSizeLabel = 9; % Schriftgroesse Label
fontTypeLabel = 'Arial'; % Schriftart Labels
fontSizeLegend = 8; % Schriftgroesse Legend
fontTypeLegend = 'Arial'; % Schriftart Legend

% Colors
Gray1 = [ 88   88  90]/255; 
Gray2 = [156  157 159]/255; 
Gray3 = [217  218 219]/255; 
Blue1 = [  0   51   89]/255; 
Blue2 = [  0   82  147]/255; 
Blue3 = [  0  115  207]/255; 
Blue4 = [100  160  200]/255; 
Orange = [227  114   34]/255;
Green  = [162  173    0]/255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(figureHandle)
% Achsbeschriftung (Text) und Legend in Label-style
set(findall(findobj('Type','figure'),'type','text'),'FontSize',fontSizeLabel,'FontName',fontTypeLabel);
% Achsbeschriftung (Zahlen) und Legend in Axis-style
set(findall(findobj('Type','figure'),'type','axes'),'FontSize',fontSizeAxis,'FontName',fontTypeAxis )

set(findall(findobj('Type','figure'),'type','axes','Tag','legend'),'FontSize',fontSizeLegend,'FontName',fontTypeLegend )


set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[xSize ySize]);             % Papiergroesse anpassen
%set(gcf,'PaperPosition', [0.01*xSize, 0.01*ySize, 0.99*xSize, 0.99*ySize]); % Position der figure auf Papier anpassen
set(gcf,'PaperPosition', [0, 0, xSize, ySize]); % Position der figure auf Papier anpassen


checkAndCreateFolder(obj.outputFigureFolder);
figureNameWithoutSpaces = strrep(figureHandle.Name,' ','_');
fileName = strcat('./',obj.outputFigureFolder,'/',...
                        prefix,'_',figureNameWithoutSpaces);
for f = 1:length(obj.outputFormat)
    print(gcf, char(obj.outputFormat{f}), fileName);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end