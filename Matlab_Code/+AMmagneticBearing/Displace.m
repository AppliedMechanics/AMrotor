%% Displace
% Ein Mesh wird erzeugt, durch Kräfte wird es verformt. Das verformte Mesh
% wird dann an den Algorithmus zur Berechnung der Lagerkräfte übergeben.

%% Aufräumen
clear all;
close all;
clc;

%% Importieren der Bibliothek
import AMmagneticBearing.2D_Matlab.*

%% FEM-Parameter
geoOrder='linear'; %Default: Linear
Hmax=0.00; %0: Automatisch
Hmin=0; %0:Automatisch
Hgrad=1.3; %Default: 1.3

%% Modell erzeugen
Configuration_ML_ANTON_Displace;
ML=MagneticBearing('Anton',cnfg);
ML.model=createpde();
ML.generate_geometry(cnfg.geometry);
pdegplot(ML.model,'FaceLabels','on');

%% Linien und Flächen zuweisen
faces.Luft=[3,24,27,30,28,25,26,23,29];
faces.Eisen=[1,2,4,5,6];
faces.Welle=[6];
faces.SpuleA_1=[7,9];
faces.SpuleB_1=[8,11];
faces.SpuleA_2=[15,21];
faces.SpuleB_2=[17,19];
faces.SpuleA_3=[12,14];
faces.SpuleB_3=[13,10];
faces.SpuleA_4=[22,16];
faces.SpuleB_4=[20,18];

%% Meshen und Assoc extrahieren
generateMesh(ML.model,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
figure(2),pdemesh(ML.model.Mesh);
F = ML.model.facetAnalyticGeometry(ML.model.Geometry);
[nodes, tri, cas, fas, eas, vas, Hmax, Hmin, Hgrad, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
assoc = pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);
[p e t]=meshToPet(ML.model.Mesh);

%% Mesh deformieren
dx=0.0007;dy=0.0007;
Verschiebung=Welle_Bewegen(ML.model.Mesh,dx,dy);
WellenNodes=t(1,t(4,:)==faces.Welle); %Mögl. persistent
Verschiebung.ux(WellenNodes)=dx;
Verschiebung.uy(WellenNodes)=dy;

NeueNodes=[ML.model.Mesh.Nodes(1,:)+Verschiebung.ux';...
           ML.model.Mesh.Nodes(2,:)+Verschiebung.uy'];
       
ML.model.Mesh= pde.FEMesh(NeueNodes,ML.model.Mesh.Elements,ML.model.Mesh.MaxElementSize,ML.model.Mesh.MinElementSize,ML.model.Mesh.MeshGradation,ML.model.Mesh.GeometricOrder,assoc);
figure(3),pdemesh(ML.model.Mesh)

%% Magnetische Lösung
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
% ML.solve();
