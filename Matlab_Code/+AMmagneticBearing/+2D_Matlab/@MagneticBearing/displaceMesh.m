function [NewNodes]=displaceMesh(self,position)
%% Variablen
persistent MechanicModel WellenNodes
if isempty(MechanicModel) %Nur ein mal ausführen, spart rechenzeit
    %% Mesh-Parameter
    geoOrder='linear'; %Default: Linear
    Hmax=0; %0: Automatisch
    Hmin=0; %0:Automatisch
    Hgrad=1.3; %Default: 1.3
    %% Geometrie definieren
    C1 = [1,0,0,self.cnfg.geometry.r_Welle]'; %[Kreis:1;Mitelpunkt 0,0;radius]
    C2 = [1,0,0,self.cnfg.geometry.r_Luftspalt_Aussen]';
    geom = [C1,C2];   % zu Geometrie zusammenfügen
    ns = (char('C1','C2'))'; %Namen
    sf = 'C2-C1'; %Geometrieformel
    gd = decsg(geom,sf,ns); 

    MechanicModel=createpde('structural','static-planestrain');
    geometryFromEdges(MechanicModel,gd);
    generateMesh(MechanicModel,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
    %% FEM:Basis Randbedingungen
    structuralProperties(MechanicModel,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-10,'Face',1);
    structuralBC(MechanicModel,'Edge',5:9,'Constraint','fixed'); %Ränder des Definitionsbereichs fixieren
    %% Bestimmung der zur Welle gehörigen Knoten
    [~,~,t]=meshToPet(self.model.Mesh); 
    for i=self.cnfg.faces.Welle
        WellenNodes=[WellenNodes,t(1,t(4,:)==i)];
    end

end
%% FEM:Spezielle Randbedingung
structuralBC(MechanicModel,'Edge',1:4,'Displacement',position); %"Loch" für die Welle bewegen
%% Lösen
Lo=solve(MechanicModel);
Dis=interpolateDisplacement(Lo,self.cnfg.mesh.default_Nodes(1,:),self.cnfg.mesh.default_Nodes(2,:));
Dis.ux(isnan(Dis.ux))=0; % das Displacement auf die Knoten des Hauptmodells wird berechnet.
Dis.uy(isnan(Dis.uy))=0; % Knoten, die nicht im Definitionsbereich von displaceMesh liegen erhalten NaN als Verschiebung
Dis.ux(WellenNodes)=position(1); %Knoten die zur Welle gehören werden um die Wellenverschiebung bewegt
Dis.uy(WellenNodes)=position(2);

NewNodes=[self.cnfg.mesh.default_Nodes(1,:)+Dis.ux';...
           self.cnfg.mesh.default_Nodes(2,:)+Dis.uy'];

end