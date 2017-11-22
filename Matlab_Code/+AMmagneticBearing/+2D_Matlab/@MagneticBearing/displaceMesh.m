function [NewNodes]=displaceMesh(self,position)
% displaceMesh ist eine Methode der Klasse MagneticBearing
% displaceMesh nutzt ein reduziertes mechanisches Modell des Magnetlagers
%
% Nur der Luftspalt zwischen Rotor und Stator ist mit FEs gefüllt. Der
% Stator wird als Fest angesehen, dem Rotor eine Verschiebung aufgeprägt.
% Alle Knoten des Rotors im Hauptmodell bewegen sich exakt um die
% angegebene Verschiebung. Knoten am Stator bleiben fest. Knoten im
% Luftspalt werden individuell verschoben. 
% 
% Die Welle und der Außenbereich sind "leerer Raum" da Matlab nur Randbedingungen
% an den Rändern des Definitionsbereischs verarbeiten kann, nicht zwischen Subdomains.
% 
% Bearbeiter: Georg Balke
% Benötigte Toolboxen: PDE
%% Variablen
persistent mechanicalModel WellenNodes
if isempty(mechanicalModel) %Modell nur ein Mal erzeugen, spart Rechenzeit
    %% Nebenrechnung-Mesh-Parameter
    % Parameter des Hilfsmodells, unabhängig vom Hauptmodell
    geoOrder='linear'; %Default: Linear
    Hmax=0;            %0: Automatisch
    Hmin=0;            %0: Automatisch
    Hgrad=1.3;         %Default: 1.3
    %% Nebenrechnung-Geometrie definieren
    C1 = [1,0,0,self.cnfg.geometry.r_Welle]';             % [Kreis:1;Mitelpunkt 0,0;radius]
    C2 = [1,0,0,self.cnfg.geometry.r_Luftspalt_Aussen]';
    geom = [C1,C2];                                       % zu Geometrie zusammenfügen
    ns = (char('C1','C2'))';                              % Namen der Geometrielemente
    sf = 'C2-C1';                                         % Strukturformel
    gd = decsg(geom,sf,ns);                               % Geometriematrix erzeugen

    mechanicalModel=createpde('structural','static-planestrain');  % static-planestrain erlaubt Nutzung von mechanischen Randbedingungen.
    geometryFromEdges(mechanicalModel,gd);                         % PDE-Geometrie erzeugen    
    generateMesh(mechanicalModel,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
    %% Nebenrechnung-FEM:Basis Randbedingungen
    structuralProperties(mechanicalModel,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-10,'Face',1);   % Weicher Luftspalt
    structuralBC(mechanicalModel,'Edge',5:9,'Constraint','fixed');                                              % Ränder des Definitionsbereichs fixieren
    %% Hauptmodell-Bestimmung der zur Welle gehörigen Knoten
    [~,~,t]=meshToPet(self.model.Mesh);    % Pet: Points-Edges-Triangles Darstellung eines Meshs. 
    for i=self.cnfg.faces.Welle
        WellenNodes=[WellenNodes,t(1,t(4,:)==i)]; % Spalte 4 der Triangles-Matrix enthält die Nummer der zugehörigen Subdomain
    end

end
%% Nebenrechnung-FEM:Spezielle Randbedingung und Lösung
structuralBC(mechanicalModel,'Edge',1:4,'Displacement',position); % "Loch" dass den Rotor repräsentiert bewegen
Lo=solve(mechanicalModel);
%% Hauptmodell-Übertragung
Dis=interpolateDisplacement(Lo,self.cnfg.mesh.default_Nodes(1,:),self.cnfg.mesh.default_Nodes(2,:));
Dis.ux(isnan(Dis.ux))=0;                % das Displacement an den Knoten des Hauptmodells wird berechnet.
Dis.uy(isnan(Dis.uy))=0;                % Knoten, die nicht im Definitionsbereich von displaceMesh liegen erhalten NaN als Verschiebung
Dis.ux(WellenNodes)=position(1);        % Knoten die zur Welle gehören werden exakt um die Wellenverschiebung bewegt
Dis.uy(WellenNodes)=position(2);

NewNodes=[self.cnfg.mesh.default_Nodes(1,:)+Dis.ux';...  % Die inertialen Knoten wurden in der Magnetlager-Variable hinterlegt
           self.cnfg.mesh.default_Nodes(2,:)+Dis.uy'];

end