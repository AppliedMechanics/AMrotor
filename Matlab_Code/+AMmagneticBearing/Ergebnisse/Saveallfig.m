%% Plotexportierer
% exportiert alle .fig Dateien im aktuellen Ordner in eine PDF und eine SVG
% Erstellt Unterordner wenn nicht vorhanden.
clear,clc
mkdir('.\PDF')
mkdir('.\SVG')

currentFolder=pwd;
files = dir(fullfile(currentFolder, '*.fig'));
size=10;
for i=1:length(files)
h=openfig(files(i).name);
h.PaperUnits='centimeters';
h.PaperPosition=[1 1 size size];
newfilename = strrep(files(i).name,'.fig','');
print(h,'-dpdf',strcat('.\PDF\',newfilename,'.pdf'));
print(h,'-dsvg',strcat('.\SVG\',newfilename,'.svg'));
close(h)
end
fprintf('Export abgeschlossen\n');