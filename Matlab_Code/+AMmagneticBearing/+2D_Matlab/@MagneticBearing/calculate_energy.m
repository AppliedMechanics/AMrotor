function [W] = calculate_energy(self,position,I_wire_pre,I_wire_use )
%CALCULATE_FORCE Summary of this function goes here
%   Detailed explanation goes here
%   self entspricht ML im Hauptprogramm

self.cnfg.geometry.circ(10).geo=[1,position(1),position(2),0.023,0,0,0,0,0,0];

self.generate_geometry(self.cnfg.geometry);

%faces wird hier als struct erzeugt. 
%Die Nummern der Fl�chen (im Plot ersichtlich) werden nach Material
%sortiert.
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

self.set_material(faces);

    edges.Dirichlet=[1,2,10,11];

self.set_boundary(edges);
self.mesh();

    load.SpuleA_1=(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-oben 
    load.SpuleB_1=-(I_wire_pre(2)+I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;        %y-oben 
    load.SpuleA_2=(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %x-links
    load.SpuleB_2=-(I_wire_pre(1)-I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-links
    load.SpuleA_3=(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %y-unten
    load.SpuleB_3=-(I_wire_pre(2)-I_wire_use(2))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;           %y-unten
    load.SpuleA_4=(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;            %x-rechts
    load.SpuleB_4=-(I_wire_pre(1)+I_wire_use(1))*self.cnfg.coil.n_Windungen/self.cnfg.coil.area;         %x-rechts

self.set_load(load,faces);
[result,W]=self.solve();


end

