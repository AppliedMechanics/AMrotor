function [ Fx,Fy ] = calculate_force(self, position, I_vormag, I_nutz, virtual_displacement)
%CALCULATE_FORCE Summary of this function goes here
%   Detailed explanation goes here

self.init()

W_0 = self.calculate_energy(position,I_vormag,I_nutz);

position_x=position;
position_x(1)=position_x(1)+virtual_displacement;
self.init()
W_x = self.calculate_energy(position_x,I_vormag,I_nutz);

position_y=position;
position_y(2)=position_y(2)+virtual_displacement;
self.init()
W_y = self.calculate_energy(position_y,I_vormag,I_nutz);


   Fx=(W_x-W_0)/virtual_displacement*self.cnfg.geometry.dTiefe;       
   Fy=(W_y-W_0)/virtual_displacement*self.cnfg.geometry.dTiefe; 

end

