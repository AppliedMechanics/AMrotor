function [ Fx,Fy ] = calculate_force_Displace(self, position, I_vormag, I_nutz, virtual_displacement)
% calculate_force_Displace ist eine Methode der Klasse MagneticBearing
% [ Fx,Fy ] = Magnetlager.calculate_force_Displace(position, I_vormag, I_nutz, virtual_displacement)
% Durch den Vergleich der Magnetischen Potentiale eines Ortes und eines
% benachbarten Ortes wird die Kraft in Richtung der Verschiebung bestimmt.
% Benötigte Toolboxen: PDE (Unterfunktionen)
%% Energie am Ursprungsort 
W_0 = self.calculate_energy_Displace(position,I_vormag,I_nutz);

%% Energie am Verschobenen Ort (X-Richtung)
position_x=[position(1)+virtual_displacement,position(2)];
W_x = self.calculate_energy_Displace(position_x,I_vormag,I_nutz);

%% Energie am Verschobenen Ort (Y-Richtung)
position_y=[position(1),position(2)+virtual_displacement];
W_y = self.calculate_energy_Displace(position_y,I_vormag,I_nutz);

%% Kraft ist Ableitung der Energie nach dem Weg
Fx=(W_x-W_0)/virtual_displacement*self.cnfg.geometry.dTiefe;       
Fy=(W_y-W_0)/virtual_displacement*self.cnfg.geometry.dTiefe; 
end