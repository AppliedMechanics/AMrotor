clear, close all

%% Vergleiche FRF P=5000
clear,close all
load('FRF_P5000.mat')
Pstr = 'P5000';
load('Simulation_Matrices_P5000.mat')
%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 155mm
FRF = FRF1;
inposition = 113e-3; 
outposition = 155e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_a'],'-dpng','-r400');
%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 665mm
FRF = FRF3;
inposition = 113e-3; 
outposition = 665e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_b'],'-dpng','-r400');
%% Anregung bei ML2, Antwort an Sensor Eddy L2 bei 665mm
FRF = FRF2;
inposition = 623e-3; 
outposition = 665e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_c'],'-dpng','-r400');



%% Vergleiche FRF P=3000
clear, close all
load('FRF_P3000.mat')
Pstr = 'P3000';
load('Simulation_Matrices_P5000.mat')
%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 155mm
FRF = FRF1;
inposition = 113e-3; 
outposition = 155e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_a'],'-dpng','-r400');
%% Anregung bei ML1, Antwort an Sensor Eddy L2 bei 665mm
FRF = FRF3;
inposition = 113e-3; 
outposition = 665e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_b'],'-dpng','-r400');
%% Anregung bei ML2, Antwort an Sensor Eddy L2 bei 665mm
FRF = FRF1;
inposition = 623e-3; 
outposition = 665e-3;
script_vgl_frf
print(['Vgl_FRF_',Pstr,'P5000_c'],'-dpng','-r400');