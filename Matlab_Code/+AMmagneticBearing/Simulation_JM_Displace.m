%% Simulation Magnetlager
% Beschreibung: Kennfeldberechnung von Magnetlagern als MagneticBearing Objekt
% Bearbeiter: Paul Schuler, Georg Balke
% Benoetigte Toolbox: PDE, Parallel Computing (fakultativ, in Z. 54 ausw�hlen)
% Achtung: Es existieren persistent-Variablen in displaceMesh.m  
%
% Um die realen und virtuellen Verschiebungen zu simulieren wird die einmalig
% erzeugte Meshform verzerrt. F�r jede Position werden die Knoten an
% einen anderen Ort verschoben und ein neues FEMesh-Element �hnlicher
% Geometrie erzeugt.
%
% Im internen L�sungsalgorithmus wird das FEMesh wieder ins [p e t] Format
% konvertiert. (siehe meshToPet() ) Dadurch werden die verschobenen Nodes
% als ver�nderte Geometrie wahrgenommen.
%
% Um ein neues Magnetlager zu simulieren muss daf�r eine Funktion erstellt
% werden, die die cnfg-Variable erzeugt.
% 
% cnfg = 
% 
%   struct with fields:
% 
%         name: 'Darmstadt'    % Name des Lagertyps
%         coil: [1�1 struct]   % coil.area: Fl�che eine Spule; 
%                                coil.n_Windungen: Windungszahl 
%     geometry: [1�1 struct]   % geometry.dl: dl-Matrix der Geometrie (aus decsg-Befehl);
%                                geometry.r_Welle: Radius des Rotors;
%                                geometry.r_Luftspalt_aussen: Innenradius
%                                    des Stators(geometrisch feste Kante)
%                                geometry.dTiefe: axiale L�nge des Magnetlagers
%     material: [1�1 struct]   % � und �r der Magnetlagerwerkstoffe
%        faces: [1�1 struct]   % Zuordnung der Fl�chen zu den Materialien.
%                                aus pdegplot(ML.model,'FaceLabels','on')
%                                ablesen. Welle: Bewegliche Teile hier zuordnen!
%        edges: [1�1 struct]   % edges.Dirichlet: R�nder des Simulationsbereichs
%                                aus pdegplot(ML.model,'EdgeLabels','on')       
%
%% Aufr�umen
close all
clc
clear all

%% Importieren der Bibliothek
import AMmagneticBearing.2D_Matlab.*

%% Parameter
%cnfg=Conf_ML_Anton; %cnfg-Variable erzeugt
% ODER
 cnfg=Conf_ML_Darmstadt;

cnfg.material.nonlinMu=true; % Nichtlinearit�t       

geoOrder='linear';  % Bitte wegen Verschiebealgorithmus linear Lassen!
Hmax=0.002;         % 0: Automatisch
Hmin=0;             % 0: Automatisch
Hgrad=1.5;          % Default: 1.3
% Bei Darmstadt gut:lin/0.0015/0/1.3(performance),lin/0.001/0/1.1(mitte),lin/0.0005/0/1.7 (Genauigkeit)
% Bei Anton gut: lin/0.002/0/1.5 (Hgrad kaum Einfluss;0.02 h�chste Triangle-Qualit�t)
Parallel_Computing=false;  % false: Einfache Berechnung mit Fortschrittsanzeige
                           % true:  Berechnung auf allen Rechnerkernen ohne Fortschrittsanzeige

%% Magnetlager erzeugen
ML=MagneticBearing(cnfg); % createpde wird nur einmalig im Konstruktor ausgef�hrt
ML.generate_geometry();   % aus der dl-Matrix wird die Geometrie der Simulation erzeugt
ML.set_boundary();        % Randbedingungen der PDE einmalig festlegen
ML.set_material();        % Subdomain-Eigenschaften der PDE einmalig festlegen

%% Assoc extrahieren und meshen
[~]=generateMesh(ML.model,'Hmax',Hmax,'Hmin',Hmin,...
                'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
F = ML.model.facetAnalyticGeometry(ML.model.Geometry);
[~, tri, cas, fas, eas, vas, ~,~,~, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geoOrder);
ML.cnfg.mesh.assoc= pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense);
ML.cnfg.mesh.default_Nodes=ML.model.Mesh.Nodes;
% assoc verkn�pft das erstellte geometrische Modell zum Mesh und muss bei der manuellen Erzeugung
% eines neuen FEMesh an dessen Konstruktor �bergeben werden.
clear cas eas esense F fas tri vas cnfg % Workspace sauber halten

%% Berechnen der Kennfelder
% gen_map_Displace fasst die Berechnungen in Iterationen zusammen und gibt ein
% Kennfeld zur�ck.
charmap = gen_map_Displace(ML,-0.0005:0.0005:0.0005,-2:2:2,0,0,2,1e-9,Parallel_Computing); %Letzte Zahl: 1: Parallel Computing, 0: nichtparallel
% save daten_Kennfeld_Anton.mat charmap_lin
%% Grafiken erstellen
Kp = Graphics.CharacteristicMap(['Kennlinie linear ',ML.name],charmap); % Erste Variable: Name des Plotfensters.
Kp.plot

%% Energieberechnung (Testzwecke)
%[W] = ML.calculate_energy_Displace([0,0.001],[0,2],[0,1])

%[Fx,Fy]=ML.calculate_force_Displace([0,0],[0,1],[0,2],1e-9);

% figure(2)
% ML.show_solution(result); % Dazu die R�ckgabewerte von
        % calculate_energy_Displace um result erg�nzen. 
        % (Zweiter R�ckgabewert von self.solve)

%% Meshqualitaet untersuchen (Testzwecke)
% for grad=1:9
% for size=1:8
% A=generateMesh(ML.model,'Hmax',size/2000,'Hmin',Hmin,'Hgrad',1+grad/10,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
% [p e t]=meshToPet(ML.model.Mesh);
% q = pdetriq(p,t);
% Qualitaet(size,grad)=min(q);
% end
% end
% Qualitaet(Qualitaet(:)<0.5)=0 %0.5 ist Akzeptanzgrenze von Matlab
% bar3(Qualitaet)