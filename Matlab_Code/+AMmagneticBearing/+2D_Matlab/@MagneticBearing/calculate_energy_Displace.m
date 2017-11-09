function [W] = calculate_energy_Displace(self,position,I_wire_pre,I_wire_use )
persistent p e t
%CALCULATE_FORCE Summary of this function goes here
%   Detailed explanation goes here
%   self entspricht self im Hauptprogramm
%faces wird hier als struct er.zeugt. 
%Die Nummern der Flächen (im Plot ersichtlich) werden nach Material
%sortiert.

load.SpuleA_1=(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-oben 
load.SpuleB_1=-(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;        %y-oben 
load.SpuleA_2=(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %x-links
load.SpuleB_2=-(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-links
load.SpuleA_3=(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %y-unten
load.SpuleB_3=-(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-unten
load.SpuleA_4=(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %x-rechts
load.SpuleB_4=-(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-rechts
self.set_load(load,self.cnfg.faces);
if isempty(t)
   [p e t]=meshToPet(self.model.Mesh); 
end
WellenNodes=t(1,t(4,:)==self.cnfg.faces.Welle);

Verschiebung=self.displaceMesh(position);
 Verschiebung.ux(WellenNodes)=position(1);
 Verschiebung.uy(WellenNodes)=position(2);

NeueNodes=[self.cnfg.mesh.default_Nodes(1,:)+Verschiebung.ux';...
           self.cnfg.mesh.default_Nodes(2,:)+Verschiebung.uy'];
self.model.Mesh= pde.FEMesh(NeueNodes,self.model.Mesh.Elements,self.model.Mesh.MaxElementSize,self.model.Mesh.MinElementSize,self.model.Mesh.MeshGradation,self.model.Mesh.GeometricOrder,self.cnfg.mesh.assoc);
pdemesh(self.model.Mesh)
if isempty(t)
   [p e t]=meshToPet(self.model.Mesh); 
end
WellenNodes=t(1,t(4,:)==self.cnfg.faces.Welle);

Verschiebung=self.displaceMesh(position);
 Verschiebung.ux(WellenNodes)=position(1);
 Verschiebung.uy(WellenNodes)=position(2);

NeueNodes=[self.cnfg.mesh.default_Nodes(1,:)+Verschiebung.ux';...
           self.cnfg.mesh.default_Nodes(2,:)+Verschiebung.uy'];
self.model.Mesh= pde.FEMesh(NeueNodes,self.model.Mesh.Elements,self.model.Mesh.MaxElementSize,self.model.Mesh.MinElementSize,self.model.Mesh.MeshGradation,self.model.Mesh.GeometricOrder,self.cnfg.mesh.assoc);
pdemesh(self.model.Mesh)
[W]=self.solve();

end

