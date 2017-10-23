%% Simulation Magnetlager_ANTON
% Geometrie nicht bearbeitbar. Mögliche Lösungen:
% dxf importieren
% Stl bearbeiten
% stl's addieren
% diskret+analytisch kombinieren
% aus dem Mesh zurück
%% Aufräumen
clear all;
close all;
clc;

%% Importieren der Bibliothek

import AMmagneticBearing.2D_Matlab.*

%% Berechnen einer Kraft

Configuration_ML_ANTON

ML=MagneticBearing('Anton',cnfg);

ML.init(); %cnfg --> model

%ML.generate_geometry(cnfg.geometry); %aus den punkten in cnfg werden kanten generiert, wird eine geometrie errechnet
%HIER ist die Stelle zum Importieren   
importGeometry(ML.model,'Schnitt.stl');
ML.show_geometry();

[result,W] = ML.calculate_energy([0.02,0.001],[0,2],[0,1]);% in calculate_energy werden den
  
ML.show_solution(result);
% spulen die faces zugeordnet!! 

%[Fx,Fy]=ML.calculate_force([0,0],[0,1],[0,2],1e-9);


%% Berechnen der Kennfelder

% %charmap_lin = gen_lin_map(ML,[-0.0005:0.0001:0.0005],[-2:0.5:2],[0],[0],2,1e-5);
%charmap_lin = gen_lin_map(ML,[-0.0005:0.0005:0.0005],[-1:0.5:1],[0],[0],2,1e-3);
% Anpassungen: calculate_energy: self.generate_geoetry wegkommentiert
% 
% save daten_Kennfeld.mat charmap_lin
% 
% %charmap_nonlin = gen_nonlin_map([-0.0003:0.0001:0.0003],[-2:1:2],[0],[0],1,1e-9);
% 
% %% Grafiken erstellen
% Kp = Graphics.CharacteristicMap('Kennlinie linear',charmap_lin);
% Kp.plot