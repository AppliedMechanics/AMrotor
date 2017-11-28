%% Plotexportierer
% exportiert alle .fig Dateien im aktuellen Ordner in eine PDF und eine SVG
% Erstellt Unterordner wenn nicht vorhanden.
clear,clc
mkdir('.\PDF')
mkdir('.\SVG')

currentFolder=pwd;
files = dir(fullfile(currentFolder, '*.fig'));

for i=1:length(files)
h=openfig(files(i).name);
newfilename = strrep(files(i).name,'.fig','');
print(h,'-dpdf',strcat('.\PDF\',newfilename,'.pdf'));
print(h,'-dsvg',strcat('.\SVG\',newfilename,'.svg'));
end
close all