%% Simulation Magnetlager_ANTON


%% Aufräumen

clear all;
close all;
clc;

%% Importieren der Bibliothek

import AMmagneticBearing.2D_Matlab.*

%% Berechnen einer Kraft

Configuration_ML_ANTON
ML=MagneticBearing('Anton',cnfg);

ML.init();

%ML.generate_geometry(cnfg.geometry);
%ML.show_geometry();
%ML.show_mesh();
%ML.show_solution(result);

%[result,W] = ML.calculate_energy([0,0.001],[0,2],[0,1]);

%[Fx,Fy]=ML.calculate_force([0,0],[0,1],[0,2],1e-9);


%% Berechnen der Kennfelder

charmap_lin = gen_lin_map(ML,[-0.0005:0.0001:0.0005],[-2:0.5:2],[0],[0],2,1e-5);

save daten_Kennfeld.mat charmap_lin

%charmap_nonlin = gen_nonlin_map([-0.0003:0.0001:0.0003],[-2:1:2],[0],[0],1,1e-9);

%% Grafiken erstellen
Kp = Graphics.CharacteristicMap('Kennlinie linear',charmap_lin);
Kp.plot