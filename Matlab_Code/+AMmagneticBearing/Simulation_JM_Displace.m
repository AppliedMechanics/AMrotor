%% Simulation Magnetlager_ANTON
% Zeitintensive Funktionen:
% assembleFEMatrices in ML.solve 18s von 40
% solvepde 19s von 40 (davon nocheinmal 12s findCoefficients) 

% displaceMesh braucht nur 2s von 40 !
% parfor macht aus 900s 120s Rechenzeit

%% Aufräumen
close all;
clc;
clear all;

%% Importieren der Bibliothek
import AMmagneticBearing.2D_Matlab.*

%% FEM-Parameter
geoOrder='linear'; %Default: Linear
Hmax=0.00; %0: Automatisch
Hmin=0; %0:Automatisch
Hgrad=1.3; %Default: 1.3

%% Geometrie erzeuge
Configuration_ML_ANTON_Displace; %cnfg-Variable erzeugt
ML=MagneticBearing('Anton',cnfg); %createpde schon im Konstruktor ausgeführt
ML.generate_geometry(); 
ML.set_boundary(); %an edges-Definition anpassen
ML.set_material(); %an faces-Definition anpassen

%pdegplot(ML.model,'EdgeLabels','on');

%% Assoc extrahieren und meshen
generateMesh(ML.model,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder);
F = ML.model.facetAnalyticGeometry(ML.model.Geometry);
[nodes, tri, cas, fas, eas, vas, Hmax, Hmin, Hgrad, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
ML.cnfg.mesh.assoc= pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);
ML.cnfg.mesh.default_Nodes=ML.model.Mesh.Nodes;

% assoc verknüpft das erstellte Modell zum Mesh und muss bei der Erzeugung
% eines neuen FEMesh an dessen Konstruktor übergeben werden.
%% Energieberechnung (Testzwecke)
%ML.generate_geometry(cnfg.geometry);
%ML.show_geometry();
%ML.show_mesh();
%ML.show_solution(result);

% [W] = ML.calculate_energy_Displace([0,0.001],[0,2],[0,1])

%[Fx,Fy]=ML.calculate_force([0,0],[0,1],[0,2],1e-9);

%% Berechnen der Kennfelder

tic
charmap_lin = gen_lin_map_Displace(ML,-0.0005:0.0001:0.0005,-2:0.3:2,0,0,2,1e-5);
toc
%save daten_Kennfeld.mat charmap_lin
%charmap_nonlin noch nicht geändert
%charmap_nonlin = gen_nonlin_map([-0.0003:0.0001:0.0003],[-2:1:2],[0],[0],1,1e-9);

%% Grafiken erstellen
Kp = Graphics.CharacteristicMap('Kennlinie linear',charmap_lin);
Kp.plot