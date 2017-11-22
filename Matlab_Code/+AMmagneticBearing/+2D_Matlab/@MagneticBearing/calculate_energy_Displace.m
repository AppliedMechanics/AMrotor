function [W] = calculate_energy_Displace(self,position,I_wire_pre,I_wire_use )
% calculate_energy_Displace ist eine Methode der Klasse MagneticBearing
% Das Potential des Rotors im Magnetfeld wird an einem bestimmten Ort zu einer bestimmte
% Stromstärke berechnet.
% Energie=Magnetlager.calculate_energy_Displace(Position(x-y als Vektor),I_wire_pre,I_wire_use)
% Benötigte Toolboxen: PDE(Unterfunktionen)
%% Berechnung der Ströme
load.SpuleA_1=(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-oben 
load.SpuleB_1=-(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;        %y-oben 
load.SpuleA_2=(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %x-links
load.SpuleB_2=-(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-links
load.SpuleA_3=(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %y-unten
load.SpuleB_3=-(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-unten
load.SpuleA_4=(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %x-rechts
load.SpuleB_4=-(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-rechts
% Koeffizienten der PDGL festlegen
self.set_load(load);

%% Mesh verzerren
NewNodes=self.displaceMesh(position);                               % displaceMesh liefert die Nodes einer Verzerrten Geometrie zurück
self.model.Mesh= pde.FEMesh(NewNodes,self.model.Mesh.Elements,...   % da FEMesh Elemente read-only sind muss in jeder Iteration ein neues erzeugt werden.
    self.model.Mesh.MaxElementSize,self.model.Mesh.MinElementSize,...
    self.model.Mesh.MeshGradation,self.model.Mesh.GeometricOrder,...
    self.cnfg.mesh.assoc);

%% FEM lösen
[W]=self.solve();

end

