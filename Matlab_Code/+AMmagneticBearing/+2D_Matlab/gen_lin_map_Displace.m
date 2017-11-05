function [ map ] = gen_lin_map(ML, posx_array, Ix_nutz_array,posy_array, Iy_nutz_array, I_vormag, virtual_displacement)
%GEN_LIN_CHARMAP Summary of this function goes here
%   Detailed explanation goes here

map = containers.Map();

map('virtual_displacement')=virtual_displacement;
map('I_vormag')=I_vormag;

n=1;n1=1;
for Ix = Ix_nutz_array
   for x = posx_array
    y=0;
    Iy=0;
       [ Fx,Fy ] = ML.calculate_force_Displace([x,y], [I_vormag,I_vormag],[Ix,Iy], virtual_displacement);
    x_vec(n,n1)=x;
    Ix_vec(n,n1)=Ix;
    map_xIxFx(n,n1)=Fx;
    map_xIxFy(n,n1)=Fy;
    n=n+1;
   end
   n1=n1+1;
   n=1;
end

map('xIxFx')=map_xIxFx;
map('xIxFy')=map_xIxFy;
map('x')=x_vec;
map('Ix')=Ix_vec;

n=1;n1=1;
for Iy = Iy_nutz_array
   for y = posy_array
    x=0;
    Ix=0;
       [ Fx,Fy ] = ML.calculate_force_Displace([x,y], [I_vormag,I_vormag],[Ix,Iy], virtual_displacement);
    y_vec(n,n1)=y;
    Iy_vec(n,n1)=Iy;
    map_yIyFy(n,n1)=Fy;
    map_yIyFx(n,n1)=Fx;
    n=n+1;
   end
   n1=n1+1;
   n=1;
end

map('yIyFy')=map_yIyFy;
map('yIyFx')=map_yIyFx;
map('y')=y_vec;
map('Iy')=Iy_vec;

end

