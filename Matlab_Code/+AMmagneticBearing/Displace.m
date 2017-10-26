%% Displace
% Ein Mesh wird erzeugt, durch Kräfte wird es verformt. das verformte mesh
% wird an den algorithmus zur magnetischen lösung übergeben.
%% Aufräumen

clear all;
close all;
clc;

%% Importieren der Bibliothek

import AMmagneticBearing.2D_Matlab.*

%% Geometrie erzeugen, meshen
Configuration_ML_ANTON
ML=MagneticBearing('Anton',cnfg);
ML.init();

ML.generate_geometry(cnfg.geometry);
ML.show_geometry();
ML.mesh();
ML.show_mesh;

faces.Luft=[3,24,27,30,28,25,26,23,29];
faces.Eisen=[1,2,6,4,5];
faces.SpuleA_1=[7,9];
faces.SpuleB_1=[8,11];
faces.SpuleA_2=[15,21];
faces.SpuleB_2=[17,19];
faces.SpuleA_3=[12,14];
faces.SpuleB_3=[13,10];
faces.SpuleA_4=[22,16];
faces.SpuleB_4=[20,18];


%% Mechanische Lösung
    faces.Luft=[3,24,27,30,28,25,26,23,29];
    faces.Fest=[1,2,6,4,5,7,9,8,11,15,21,17,19,12,14,...
        13,10,22,16,20,18];
% Luft: geringen Emodul, Fest hohen!
% TODO alle 3 müssen noch eingestellt werden.
ML.set_material_mech(faces);
edges.Dirichlet=[1,2,10,11];
% edges.neumann?
ML.set_boundary(edges);

%% Magnetische Lösung
%     %set_material besteht aus "specifyCoefficients am model  
%     ML.set_material(faces);
%     edges.Dirichlet=[1,2,10,11];
%     ML.set_boundary(edges);
% self.set_load(load,faces);
% [result,W]=self.solve()
