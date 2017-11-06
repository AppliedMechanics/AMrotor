%% Displace
% Ein Mesh wird erzeugt, durch Kräfte wird es verformt. Das verformte Mesh
% wird dann an den Algorithmus zur Berechnung der Lagerkräfte übergeben.
% TODO: Randbedingungen funktionieren nicht.

%% Aufräumen
clear;
close all;
clc;

%% Importieren der Bibliothek
import AMmagneticBearing.2D_Matlab.*

%% FEM-Parameter
geoOrder='linear'; %Default: Linear
Hmax=0; %0: Automatisch
Hmin=0; %0:Automatisch
Hgrad=1.5; %Default: 1.5

%% Modell erzeugen
Configuration_ML_ANTON_Displace;
ML=MagneticBearing('Anton',cnfg);
ML.model=createpde('structural','static-planestrain');
ML.generate_geometry(cnfg.geometry);
% pdegplot(ML.model,'EdgeLabels','on');

%% Linien und Flächen zuweisen
faces.Luft=[3,24,27,30,28,25,26,23,29];
faces.Eisen=[1,2,4,5];
faces.Welle=6;
faces.SpuleA_1=[7,9];
faces.SpuleB_1=[8,11];
faces.SpuleA_2=[15,21];
faces.SpuleB_2=[17,19];
faces.SpuleA_3=[12,14];
faces.SpuleB_3=[13,10];
faces.SpuleA_4=[22,16];
faces.SpuleB_4=[20,18];

faces.Hart=[faces.Welle,faces.Eisen,faces.SpuleA_1,faces.SpuleB_1,faces.SpuleA_2,faces.SpuleB_2,faces.SpuleA_3,faces.SpuleB_3,faces.SpuleA_4,faces.SpuleB_4];

edges.Welle=133:148;
edges.Fix=1:132;

Wellenknoten=[133:148,556:563];

%% Randbedingungen (mechanisch)
% Luft: geringer Emodul, Eisen hoch, Kupfer hoch
% Mit Strukturtools:
% Assign structural properties of a material for a structural model
structuralProperties(ML.model,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-10,'Face',faces.Luft);	
structuralProperties(ML.model,'YoungsModulus',2e9,'PoissonsRatio',0.3,'MassDensity',1,'Face',faces.Hart);

%Specify boundary conditions for a structural model
%Testzwecke Gravitation:

structuralBC(ML.model,'Edge',edges.Fix,  'Constraint','fixed');
structuralBC(ML.model,'Edge',edges.Welle,'Displacement',[1 1]);
% structuralBodyLoad(ML.model,'GravitationalAcceleration',3*[1 1]);

%% Meshen und Assoc extrahieren
generateMesh(ML.model,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder);
figure(2),pdemesh(ML.model.Mesh);
F = ML.model.facetAnalyticGeometry(ML.model.Geometry);
[nodes, tri, cas, fas, eas, vas, Hmax, Hmin, Hgrad, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
assoc = pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);

%% PDE lösen (mechanisch)
A=solve(ML.model);
Geo=ML.model.Geometry;

Knotenmatrix=[A.Mesh.Nodes(1,:)+A.Displacement.ux';...
              A.Mesh.Nodes(2,:)+A.Displacement.uy'];
% A.Displacement.Magnitude ist Verschiebeweg (Pythagoras aus ux und uy)

%% Magnetische Lösung
% set_material besteht aus "specifyCoefficients" am model 
ML.model=createpde(); %anstatt ML.init();
ML.model.Geometry=Geo;
ML.model.Mesh= pde.FEMesh(Knotenmatrix,A.Mesh.Elements,A.Mesh.MaxElementSize,A.Mesh.MinElementSize,A.Mesh.MeshGradation,A.Mesh.GeometricOrder,assoc);
figure(3),pdemesh(ML.model.Mesh)
faces.Eisen=[1,2,4,5,6];
ML.set_material(faces);  %an faces-Definition anpassen
edges.Dirichlet=[1,2,10,11];
ML.set_boundary(edges);
    load.SpuleA_1=1;%(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-oben 
    load.SpuleB_1=1;%-(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;        %y-oben 
    load.SpuleA_2=1;%(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %x-links
    load.SpuleB_2=1;%-(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-links
    load.SpuleA_3=1;%(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %y-unten
    load.SpuleB_3=1;%-(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-unten
    load.SpuleA_4=1;%(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %x-rechts
    load.SpuleB_4=1;%-(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-rechts
ML.set_load(load,faces);
ML.solve();
