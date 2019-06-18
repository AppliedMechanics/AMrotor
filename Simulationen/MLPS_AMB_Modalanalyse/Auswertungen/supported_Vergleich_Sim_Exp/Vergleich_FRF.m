clear, close all

%% Vergleiche FRF P=5000
clear,close all
load('FRF_P5000.mat')
Pstr = 'P5000';
load('Simulation_Matrices_P5000.mat')
InputString = {'113mm','623mm'};%<- Werte aus MA Kreutz Appendix; rechts: alte Werte:{'67.5mm','587.5mm'}; % Positionen des Inputs
InputStringNames = {'MLL','MLR'};
OutputString = {'71mm','113mm','155mm','363mm','581mm','623mm','665mm'};%<- Werte aus MA Kreutz Appendix; rechts: alte Werte:{'25mm','67.5mm','110mm','315mm','545mm','587.5mm','630mm'}; % Positionen des Outputs
OutputStringNames = {'EddyL1','MLL','EddyL2','Laser','EddyR1','MLR','EddyR2'};

%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 155mm
close all
indexInput=1;
indexOutput=3;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei ML1, Antwort an Sensor Eddy R2 bei 665mm
close all
indexInput=1;
indexOutput=7;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei ML2, Antwort an Sensor Eddy R2 bei 665mm
close all
indexInput=2;
indexOutput=7;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLL, Antwort an Sensor MLL
close all
indexInput=1;
indexOutput=2;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLR, Antwort an Sensor MLR
close all
indexInput=2;
indexOutput=6;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLL, Antwort an Sensor Laser
close all
indexInput=1;
indexOutput=4;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLR, Antwort an Sensor Laser
close all
indexInput=2;
indexOutput=4;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');

%% Anregung bei MLR, Antwort an Sensor Laser (nur Experiment)
close all
indexInput=2;
indexOutput=4;
script_plot_experiment



%% Vergleiche FRF P=3000
clear, close all
load('FRF_P3000.mat')
Pstr = 'P3000';
load('Simulation_Matrices_P3000.mat')
InputString = {'113mm','623mm'};%<- Werte aus MA Kreutz Appendix; rechts: alte Werte:{'67.5mm','587.5mm'}; % Positionen des Inputs
InputStringNames = {'MLL','MLR'};
OutputString = {'71mm','113mm','155mm','363mm','581mm','623mm','665mm'};%<- Werte aus MA Kreutz Appendix; rechts: alte Werte:{'25mm','67.5mm','110mm','315mm','545mm','587.5mm','630mm'}; % Positionen des Outputs
OutputStringNames = {'EddyL1','MLL','EddyL2','Laser','EddyR1','MLR','EddyR2'};

%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 155mm
indexInput=1;
indexOutput=3;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei ML1, Antwort an Sensor Eddy R2 bei 665mm
close all
indexOutput=7;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei ML2, Antwort an Sensor Eddy R2 bei 665mm
close all
indexInput=2;
indexOutput=7;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLL, Antwort an Sensor MLL
close all
indexInput=1;
indexOutput=2;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLR, Antwort an Sensor MLR
indexInput=2;
indexOutput=6;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLL, Antwort an Sensor Laser
close all
indexInput=1;
indexOutput=4;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');
%% Anregung bei MLR, Antwort an Sensor Laser
close all
indexInput=2;
indexOutput=4;
script_vgl_frf2
print(figBodeKoh,['plots/Vgl_FRF_',Pstr,TitleFilename],'-dpng','-r400');
print(figNyquist,['plots/Vgl_Nyquist_',Pstr,TitleFilename],'-dpng','-r400');