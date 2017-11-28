%% Aufräumen
close all
clc
clear all

%% Importieren der Bibliothek
import AMmagneticBearing.2D_Matlab.*

%% Magnetlager erzeugen
cnfg=Conf_ML_Darmstadt;
cnfg.material.nonlinMu=true;

ML=MagneticBearing(cnfg); % createpde wird nur einmalig im Konstruktor ausgeführt
ML.generate_geometry();   % aus der dl-Matrix wird die Geometrie der Simulation erzeugt
ML.set_boundary();        % Randbedingungen der PDE einmalig festlegen
ML.set_material();        % Subdomain-Eigenschaften der PDE einmalig festlegen

%% Meshqualitaet untersuchen
% for grad=1:9
% for size=1:8
% A=generateMesh(ML.model,'Hmax',size/2000,'Hmin',0,'Hgrad',1+grad/10,'GeometricOrder','linear','MesherVersion','R2013a');
% [p e t]=meshToPet(ML.model.Mesh);
% q = pdetriq(p,t);
% Qualitaet(size,grad)=min(q);
% end
% end
% Qualitaet(Qualitaet(:)<0.5)=0 %0.5 ist Akzeptanzgrenze von Matlab
% figure(1),bar3(Qualitaet)
% % Ergebnis: 67,5% Qualität bei  Hgrad=1.1, Hmax=0.002 (4/2000)

%% Parameter Festlegen
geoOrder='linear'  % Bitte wegen Verschiebealgorithmus linear Lassen!
Hmax=0.002         % 0: Automatisch
Hmin=0             % 0: Automatisch
Hgrad=1.1         % Default: 1.3

%% Assoc extrahieren und meshen
[~]=generateMesh(ML.model,'Hmax',Hmax,'Hmin',Hmin,...
                'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
F = ML.model.facetAnalyticGeometry(ML.model.Geometry);
[~, tri, cas, fas, eas, vas, ~,~,~, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
ML.cnfg.mesh.assoc= pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);
ML.cnfg.mesh.default_Nodes=ML.model.Mesh.Nodes;
% assoc verknüpft das erstellte geometrische Modell zum Mesh und muss bei der manuellen Erzeugung
% eines neuen FEMesh an dessen Konstruktor übergeben werden.

%% Untersuchung der Virtuellen Verschiebung
% for i=4:15
%     [~,Fy_Vector(i)] = ML.calculate_force_Displace([0,0], [2.5,2.5],[0,1], 10^(-i));
%     end
%     figure(2),semilogx(10.^(-4:-1:-15),Fy_Vector(4:15)),xlabel('Virtual Displacement'),ylabel('Fy Ergebnis')
 virtual_displacement=1e-10 %Liegt in der Mitte des Plateaus

%% Kennfeld ermitteln
posy_array=-0.7e-3:0.1e-3:0.7e-3;
I_vormag_x=2.5;
I_vormag_y=2.5;
Iy_nutz_array=-2.5:0.25:2.5;
x=0;Ix=0;
Ergebnis_lin=zeros(length(Iy_nutz_array)*length(posy_array),8);
Ergebnis_nonlin=zeros(length(Iy_nutz_array)*length(posy_array),8);
Size_1=length(posy_array);
Size_2=length(Iy_nutz_array);

% ML.cnfg.material.nonlinMu=false; % linear 
% ML.set_material()
% 
% Rechnungen=Size_1*Size_2
% Schritt=0; Zeit=0; n
% 
% for n1=1:Size_2
%    for n=1:Size_1
%     tic
%     [Fx,Fy] = ML.calculate_force_Displace([x,posy_array(n)], [I_vormag_x,I_vormag_y],[Ix,Iy_nutz_array(n1)], virtual_displacement);
%     
%     Position=(n1-1)*Size_1+n;
%     
%     Ergebnis_lin(Position,1)=x;
%     Ergebnis_lin(Position,2)=posy_array(n);
%     Ergebnis_lin(Position,3)=I_vormag_x;
%     Ergebnis_lin(Position,4)=I_vormag_y;
%     Ergebnis_lin(Position,5)=Ix;
%     Ergebnis_lin(Position,6)=Iy_nutz_array(n1);
%     Ergebnis_lin(Position,7)=Fx;
%     Ergebnis_lin(Position,8)=Fy;
%     
%     Schritt=Schritt+1;
%     Zeit=Zeit+toc;
%     Restzeit=(Zeit/Schritt)*(Rechnungen-Schritt);
%     fprintf('Fortschritt: %.0f%%  Restzeit:%.1fs\n',Schritt*100/Rechnungen,Restzeit)
% 
%     end
% end

% ML.cnfg.material.nonlinMu=true; % nichtlinear 
% ML.set_material();     % Nötig um nonlin anzuwenden
% 
% Rechnungen=Size_1*Size_2
% Schritt=0; Zeit=0;
% 
% for n1=1:length(Iy_nutz_array)
%    for n=1:length(posy_array)
%     tic
%     [Fx,Fy] = ML.calculate_force_Displace([x,posy_array(n)], [I_vormag_x,I_vormag_y],[Ix,Iy_nutz_array(n1)], virtual_displacement);
%     
%     Position=(n1-1)*length(posy_array)+n;
%     
%     Ergebnis_nonlin(Position,1)=x;
%     Ergebnis_nonlin(Position,2)=posy_array(n);
%     Ergebnis_nonlin(Position,3)=I_vormag_x;
%     Ergebnis_nonlin(Position,4)=I_vormag_y;
%     Ergebnis_nonlin(Position,5)=Ix;
%     Ergebnis_nonlin(Position,6)=Iy_nutz_array(n1);
%     Ergebnis_nonlin(Position,7)=Fx;
%     Ergebnis_nonlin(Position,8)=Fy;
%         Schritt=Schritt+1;
%     Zeit=Zeit+toc;
%     Restzeit=(Zeit/Schritt)*(Rechnungen-Schritt);
%     fprintf('Fortschritt: %.0f%%  Restzeit:%.1fs\n',Schritt*100/Rechnungen,Restzeit)
% 
%     end
% end
%  save Kennfelder_neu.mat Ergebnis_nonlin Ergebnis_lin
 load('Kennfelder.mat')
%% Geometrieplot
% figure(3)
% pdegplot(ML.model,'FaceLabels','on')

%% Meshplot (magnetisch, unverzerrt)
% figure(4)
% NewNodes=ML.displaceMesh([0 0]);                               % displaceMesh liefert die Nodes einer Verzerrten Geometrie zurück
% ML.model.Mesh= pde.FEMesh(NewNodes,ML.model.Mesh.Elements,...   % da FEMesh Elemente read-only sind muss in jeder Iteration ein neues erzeugt werden.
%     ML.model.Mesh.MaxElementSize,ML.model.Mesh.MinElementSize,...
%     ML.model.Mesh.MeshGradation,ML.model.Mesh.GeometricOrder,...
%     ML.cnfg.mesh.assoc);
% pdemesh(ML.model)

%% Vektorpotentialplot
% figure(5)
%     I_wire_pre=[2.5 2.5];I_wire_use=[0 1];
%     load.SpuleA_1=(I_wire_pre(2)+I_wire_use(2))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;           %y-oben 
%     load.SpuleB_1=-(I_wire_pre(2)+I_wire_use(2))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;        %y-oben 
%     load.SpuleA_2=(I_wire_pre(1)-I_wire_use(1))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;           %x-links
%     load.SpuleB_2=-(I_wire_pre(1)-I_wire_use(1))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;         %x-links
%     load.SpuleA_3=(I_wire_pre(2)-I_wire_use(2))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;            %y-unten
%     load.SpuleB_3=-(I_wire_pre(2)-I_wire_use(2))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;           %y-unten
%     load.SpuleA_4=(I_wire_pre(1)+I_wire_use(1))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;            %x-rechts
%     load.SpuleB_4=-(I_wire_pre(1)+I_wire_use(1))*ML.cnfg.coil.n_Windungen/ML.cnfg.coil.area;         %x-rechts
%     % Koeffizienten der PDGL festlegen
%     ML.set_load(load);
%     solution=solvepde(ML.model);
% pdegplot(ML.model,'EdgeLabels','off','FaceLabels','off');    % Plotten der Geometrie mit Fasen-Beschriftung
% hold on,axis equal;
% pdeplot(ML.model,'Mesh','off','FaceAlpha',0.1,'Contour','on','ColorMap','parula','XYData',solution.NodalSolution)
% title ('Magnetisches Vektorpotential','Interpreter','latex');
% xlabel('x / m','Interpreter','latex'),ylabel('y / m','Interpreter','latex');
% hold off;

%% Meshplot (mechanisch, unverzerrt)
% figure(6)
%     Nebenrechnung Meshparameter
%     geoOrder='linear'; %Default: Linear
%     Hmax=0;            %0: Automatisch
%     Hmin=0;            %0: Automatisch
%     Hgrad=1.3;         %Default: 1.3
%     Nebenrechnung-Geometrie definieren
%     C1 = [1,0,0,ML.cnfg.geometry.r_Welle]';             % [Kreis:1;Mitelpunkt 0,0;radius]
%     C2 = [1,0,0,ML.cnfg.geometry.r_Luftspalt_Aussen]';
%     geom = [C1,C2];                                       % zu Geometrie zusammenfügen
%     ns = (char('C1','C2'))';                              % Namen der Geometrielemente
%     sf = 'C2-C1';                                         % Strukturformel
%     gd = decsg(geom,sf,ns);                               % Geometriematrix erzeuge
%     mechanicalModel=createpde('structural','static-planestrain');  % static-planestrain erlaubt Nutzung von mechanischen Randbedingungen.
%     geometryFromEdges(mechanicalModel,gd);                         % PDE-Geometrie erzeugen    
%    
%     [~]=generateMesh(mechanicalModel,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
%     F = mechanicalModel.facetAnalyticGeometry(mechanicalModel.Geometry);
%     [~, tri, cas, fas, eas, vas, ~,~,~, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
%     mechanicalModelAssoc= pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);
% pdemesh(mechanicalModel.Mesh)

%% Meshplot (mechanisch, verzerrt)
% figure(7)
%     structuralProperties(mechanicalModel,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-10,'Face',1);   % Weicher Luftspalt
%     structuralBC(mechanicalModel,'Edge',5:9,'Constraint','fixed');                                              % Ränder des Definitionsbereichs fixieren
%     structuralBC(mechanicalModel,'Edge',1:4,'Displacement',[0 0.5e-3]); % "Loch" dass den Rotor repräsentiert bewegen
%     Lo=solve(mechanicalModel);
%     NewNodes=[mechanicalModel.Mesh.Nodes(1,:)+Lo.Displacement.ux'...
%              ;mechanicalModel.Mesh.Nodes(2,:)+Lo.Displacement.uy'];
%     mechanicalModel.Mesh=pde.FEMesh(NewNodes,mechanicalModel.Mesh.Elements,...   % da FEMesh Elemente read-only sind muss in jeder Iteration ein neues erzeugt werden.
%         mechanicalModel.Mesh.MaxElementSize,mechanicalModel.Mesh.MinElementSize,...
%         mechanicalModel.Mesh.MeshGradation,mechanicalModel.Mesh.GeometricOrder,...
%         mechanicalModelAssoc);
% pdemesh(mechanicalModel.Mesh)

%% Kennfeldplots
figure(8)
% Rekonstruktion Matrixstruktur
y_range=sort(unique(Ergebnis_lin(:,2)));
Iy_range=sort(unique(Ergebnis_lin(:,6)));
Z=zeros(length(y_range),length(Iy_range));

for i=1:length(y_range)
    for j=1:length(Iy_range)
        Z(i,j)=Ergebnis_lin( (Ergebnis_lin(:,2)==y_range(i))&(Ergebnis_lin(:,6)==Iy_range(j))  ,8);
    end
end
surf(y_range,Iy_range,Z')
title('Kennfeld y-Richtung linear','Interpreter','latex');
ylabel('Differenzstrom in y-Richtung / A', 'Interpreter', 'latex');
xlabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');

figure(9)
% Rekonstruktion Matrixstruktur
y_range2=sort(unique(Ergebnis_nonlin(:,2)));
Iy_range2=sort(unique(Ergebnis_nonlin(:,6)));
Z2=zeros(length(y_range),length(Iy_range));

for i=1:length(y_range2)
    for j=1:length(Iy_range2)
        Z2(i,j)=Ergebnis_nonlin( (Ergebnis_nonlin(:,2)==y_range2(i))&(Ergebnis_nonlin(:,6)==Iy_range2(j))  ,8);
    end
end
surf(y_range2,Iy_range2,Z2')
title('Kennfeld y-Richtung nichtlinear','Interpreter','latex');
ylabel('Differenzstrom in y-Richtung / A', 'Interpreter', 'latex');
xlabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');

figure(10),surf(y_range2,Iy_range2,Z2'-Z')

%% Nichtlinearität Untersuchung
% figure(11)
% W1=[];W2=[];
% ML.cnfg.material.nonlinMu=false; % linear 
% ML.set_material()
% for i=1:10
% W1(end+1) = ML.calculate_energy_Displace([0,0.001],[2.5 2.5],[0,10^i]);
% end
% 
% ML.cnfg.material.nonlinMu=true; % linear
% ML.set_material()
% for i=1:10
% W2(end+1) = ML.calculate_energy_Displace([0,0.001],[2.5 2.5],[0,10^i]);
% end
% 
% loglog(10.^(1:10),W1,10.^(1:10),W2)


% figure(2)
% ML.show_solution(result); % Dazu die Rückgabewerte von
        % calculate_energy_Displace um result ergänzen. 
        % (Zweiter Rückgabewert von self.solve)