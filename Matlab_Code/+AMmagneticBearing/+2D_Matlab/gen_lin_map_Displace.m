function [ map ] = gen_lin_map_Displace(self, posx_array, Ix_nutz_array,posy_array, Iy_nutz_array, I_vormag, virtual_displacement)
%GEN_LIN_CHARMAP Summary of this function goes here
%   Detailed explanation goes here
% TODO: Vektoren initialisieren
map = containers.Map();
map('virtual_displacement')=virtual_displacement;
map('I_vormag')=I_vormag;
%% Vektoren initialisieren
Size_X=[length(posx_array),length(Ix_nutz_array)];
x_vec=zeros(Size_X);
Ix_vec=zeros(Size_X);
map_xIxFx=zeros(Size_X);
map_xIxFy=zeros(Size_X);

Size_Y=[length(posy_array),length(Iy_nutz_array)];
y_vec=zeros(Size_Y);
Iy_vec=zeros(Size_Y);
map_yIyFy=zeros(Size_Y);
map_yIyFx=zeros(Size_Y);

y=0;Iy=0;
for n1=1:Size_X(2)%Ix = Ix_nutz_array
   for n=1:Size_X(1)%x = posx_array
    [Fx,Fy] = self.calculate_force_Displace([posx_array(n),y], [I_vormag,I_vormag],[Ix_nutz_array(n1),Iy], virtual_displacement);
    x_vec(n,n1)=posx_array(n);
    Ix_vec(n,n1)=Ix_nutz_array(n1);
    map_xIxFx(n,n1)=Fx;
    map_xIxFy(n,n1)=Fy;
   end
end

map('xIxFx')=map_xIxFx;
map('xIxFy')=map_xIxFy;
map('x')=x_vec;
map('Ix')=Ix_vec;

x=0;Ix=0;
for n1=1:Size_Y(2)%Iy = Iy_nutz_array
   for n=1:Size_Y(1)%y = posy_array
    [Fx,Fy] = self.calculate_force_Displace([x,posy_array(n)], [I_vormag,I_vormag],[Ix,Iy_nutz_array(n1)], virtual_displacement);
    y_vec(n,n1)=posy_array(n);
    Iy_vec(n,n1)=Iy_nutz_array(n1);
    map_yIyFy(n,n1)=Fy;
    map_yIyFx(n,n1)=Fx;
   end
end

map('yIyFy')=map_yIyFy;
map('yIyFx')=map_yIyFx;
map('y')=y_vec;
map('Iy')=Iy_vec;

end

