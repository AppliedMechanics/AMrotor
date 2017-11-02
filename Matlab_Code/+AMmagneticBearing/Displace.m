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
Configuration_ML_ANTON;
ML=MagneticBearing('Anton',cnfg);
ML.model=createpde('structural','static-planestress'); %anstatt ML.init();
ML.generate_geometry(cnfg.geometry);
generateMesh(ML.model);
%ML.mesh();
%pdegplot(ML.model,'EdgeLabels','off');

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
faces.Welle=6;

edges.Welle=133:148;
edges.Fix=1:132;

%% Mechanische Lösung
% Luft: geringer Emodul, Eisen hoch, Kupfer hoch

%%Mit Strukturtools:
%Assign structural properties of a material for a structural model
structuralProperties(ML.model,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-5,'Face',faces.Luft);	
structuralProperties(ML.model,'YoungsModulus',2.1e11,'PoissonsRatio',0.3,'MassDensity',8e3,'Face',faces.Hart);

%Specify boundary conditions for a structural model
%Testzwecke Gravitation:
structuralBodyLoad(ML.model,'GravitationalAcceleration',[0 -1]);

%Erzwungene Verschiebung
structuralBC(ML.model,'Constraint','fixed','Edge',edges.Fix);
structuralBC(ML.model,'YDisplacement',.005,'Edge',edges.Welle);

A=solve(ML.model)
figure(2),pdemesh(A.Mesh)
Geo=ML.model.Geometry;

Knotenmatrix=A.Mesh.Nodes;
Knotenmatrix(1,1:1000)=Knotenmatrix(1,1:1000)+1;

ML.model=createpde(1); %anstatt ML.init();
ML.generate_geometry(cnfg.geometry);
generateMeshCustom(ML.model,Knotenmatrix)
figure(3),pdemesh(ML.model.Mesh)
% in generateMeshCustom wird generateMeshFacettedAnalytic aufgerufen. dort
% wird die assoc (assoziationsstruct) erstellt die für die meshgenerierung
% wichtig ist.

%MyCustomMesh= pde.FEMesh(A.Mesh.Nodes,A.Mesh.Elements,A.Mesh.MaxElementSize,A.Mesh.MinElementSize,A.Mesh.MeshGradation,'quadratic');

% Lösung vielleicht unter https://de.mathworks.com/matlabcentral/answers/261699-how-to-create-custom-mesh-for-pde-model
% MyCustomMesh= pde.FEMesh(A.Mesh.Nodes,A.Mesh.Elements,A.Mesh.MaxElementSize,A.Mesh.MinElementSize,A.Mesh.MeshGradation,'quadratic');
% das letzte argument fehlt: assoc = pde.FEMeshAssociation(tet, cas, fas, eas, vas); 

%[result,W]=ML.solve()
%Geo=ML.model.Geometry
% FEMesh weitergeben, TODO: Neue Mesh extrahieren.
%% Magnetische Lösung
% %set_material besteht aus "specifyCoefficients am model 
%  ML.model=createpde();
%  ML.model.Mesh=A.Mesh
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
%  ML.solve()
