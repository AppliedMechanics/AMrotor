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
ML.model=createpde('structural','static-planestress'); %anstatt ML.init();

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

faces.Hart=[faces.Eisen,faces.SpuleA_1,faces.SpuleB_1,faces.SpuleA_2,faces.SpuleB_2,faces.SpuleA_3,faces.SpuleB_3,faces.SpuleA_4,faces.SpuleB_4];

%% Mechanische Lösung
% Luft: geringer Emodul, Eisen hoch, Kupfer hoch!
% TODO alle Parameter noch eingestellt werden.

%%Alt:
% ML.set_material_mech(faces);
% edges.Dirichlet=[1,2,10,11];
% edges.Neumann?
% ML.set_boundary(edges);

%%Mit Strukturtools:
structuralProperties(ML.model,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-5,'Face',faces.Luft)	%Assign structural properties of a material for a structural model
structuralProperties(ML.model,'YoungsModulus',2.1e11,'PoissonsRatio',0.3,'MassDensity',8e3,'Face',faces.Hart)
%structuralBodyLoad	%Volumenkräfte, hier nicht interessant
%structuralBoundaryLoad	%Specify boundary loads for a structural model
% structuralBC    %Specify boundary conditions for a structural model

   % 'YoungsModulus'          Young's modulus of the material.
   % 'PoissonsRatio'          Poisson's ratio of the material.
   % 'MassDensity'            Mass density of the material.
 

% [result,W]=ML.solve()
%Geo=ML.model.Geometry
%result.Mesh enthält das neue FEMesh, weitergeben
%% Magnetische Lösung
%%set_material besteht aus "specifyCoefficients am model 
%  ML.model=createpde();
%  ML.model.Mesh=result.Mesh
%  ML.model.Geometry=Geo
%  ML.set_material(faces);
%  edges.Dirichlet=[1,2,10,11];
%  ML.set_boundary(edges);
%     load.SpuleA_1=1;%(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-oben 
%     load.SpuleB_1=1;%-(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;        %y-oben 
%     load.SpuleA_2=1;%(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %x-links
%     load.SpuleB_2=1;%-(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-links
%     load.SpuleA_3=1;%(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %y-unten
%     load.SpuleB_3=1;%-(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-unten
%     load.SpuleA_4=1;%(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %x-rechts
%     load.SpuleB_4=1;%-(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-rechts
%  ML.set_load(load,faces);
%  [result,W]=ML.solve()
