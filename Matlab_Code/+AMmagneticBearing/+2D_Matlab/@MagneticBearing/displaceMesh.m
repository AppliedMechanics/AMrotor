function [Verschiebung]=displaceMesh(self,position)
%% Variablen
persistent model
if isempty(model) %Nur ein mal ausführen, spart rechenzeit
    %% Mesh-Parameter
    geoOrder='linear'; %Default: Linear
    Hmax=0; %0: Automatisch
    Hmin=0; %0:Automatisch
    Hgrad=1.3; %Default: 1.3
    %% Geometrie definieren
    C1 = [1,0,0,.023]';
    C2 = [1,0,0,.025]';
    geom = [C1,C2];
    ns = (char('C1','C2'))'; %Namen
    sf = 'C2-C1'; %Geometrieformel
    gd = decsg(geom,sf,ns);
    axis equal

    model=createpde('structural','static-planestrain');
    pg = geometryFromEdges(model,gd);
    generateMesh(model,'Hmax',Hmax,'Hmin',Hmin,'Hgrad',Hgrad,'GeometricOrder',geoOrder,'MesherVersion','R2013a');
    %% FEM:Basis Boundary Conditions
    structuralProperties(model,'YoungsModulus',1,'PoissonsRatio',0.3,'MassDensity',1e-10,'Face',1);
    structuralBC(model,'Edge',[5:9],'Constraint','fixed');
end
%% FEM:Spezielle Boundary Condition
structuralBC(model,'Edge',[1:4],'Displacement',position);
%% Lösen
Lo=solve(model);
Dis=interpolateDisplacement(Lo,self.cnfg.mesh.default_Nodes(1,:),self.cnfg.mesh.default_Nodes(2,:));
Dis.ux(isnan(Dis.ux))=0;
Dis.uy(isnan(Dis.uy))=0;
Verschiebung=Dis;
end