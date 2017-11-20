function [ map ] = gen_map_Displace(self, posx_array, Ix_nutz_array,posy_array, Iy_nutz_array, I_vormag, virtual_displacement,parallel)
% [ map ] = Magnetlager.gen_lin_map_Displace(Position_x, Ix,Position_y, Iy, I_vormag, virtual_Displacement,Parallel_Computing)
% gen_lin_map_Displace Systematisiert die Kraftberechnung am Magnetlager
% der Klasse MagneticBearing
% Erzeugung eines Kennfeldes des Magnetlagers.
% Bei nichtparalleler Berechnung wird ein Fortschrittsstatus getickert.

%% Vektoren initialisieren
map = containers.Map();
map('virtual_displacement')=virtual_displacement;
map('I_vormag')=I_vormag;

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

[~]= self.calculate_energy_Displace([0,0],[2,2],[2,2]); %Erste Rechnung um persistent-var in solve und displaceMesh zu initialisieren.

%% Kräfte berechnen
% Parallel
if parallel
y=0;Iy=0;
for n1=1:Size_X(2)
   parfor n=1:Size_X(1)
    [Fx,Fy] = self.calculate_force_Displace([posx_array(n),y], [I_vormag,I_vormag],[Ix_nutz_array(n1),Iy], virtual_displacement);
    x_vec(n,n1)=posx_array(n);
    Ix_vec(n,n1)=Ix_nutz_array(n1);
    map_xIxFx(n,n1)=Fx;
    map_xIxFy(n,n1)=Fy;
  end
end
x=0;Ix=0;
for n1=1:Size_Y(2)
   parfor n=1:Size_Y(1)
    [Fx,Fy] = self.calculate_force_Displace([x,posy_array(n)], [I_vormag,I_vormag],[Ix,Iy_nutz_array(n1)], virtual_displacement);
    y_vec(n,n1)=posy_array(n);
    Iy_vec(n,n1)=Iy_nutz_array(n1);
    map_yIyFy(n,n1)=Fy;
    map_yIyFx(n,n1)=Fx;
    end
end

else
% nichtparallel
Rechnungen=Size_X(1)*Size_X(2)+Size_Y(1)*Size_Y(2);
Schritt=0; Zeit=0;
y=0;Iy=0;
for n1=1:Size_X(2)
   for n=1:Size_X(1)
    tic
    [Fx,Fy] = self.calculate_force_Displace([posx_array(n),y], [I_vormag,I_vormag],[Ix_nutz_array(n1),Iy], virtual_displacement);
    x_vec(n,n1)=posx_array(n);
    Ix_vec(n,n1)=Ix_nutz_array(n1);
    map_xIxFx(n,n1)=Fx;
    map_xIxFy(n,n1)=Fy;
    
    Schritt=Schritt+1;
    Zeit=Zeit+toc;
    Restzeit=(Zeit/Schritt)*(Rechnungen-Schritt);
    fprintf('Fortschritt: %.0f%%  Restzeit:%.1fs\n',Schritt*100/Rechnungen,Restzeit)
  end
end
x=0;Ix=0;
for n1=1:Size_Y(2)
   for n=1:Size_Y(1)
    [Fx,Fy] = self.calculate_force_Displace([x,posy_array(n)], [I_vormag,I_vormag],[Ix,Iy_nutz_array(n1)], virtual_displacement);
    y_vec(n,n1)=posy_array(n);
    Iy_vec(n,n1)=Iy_nutz_array(n1);
    map_yIyFy(n,n1)=Fy;
    map_yIyFx(n,n1)=Fx;
    
    Schritt=Schritt+1;
    Zeit=Zeit+toc;
    Restzeit=(Zeit/Schritt)*(Rechnungen-Schritt);
    fprintf('Fortschritt: %.0f%%  Restzeit:%.1fs\n',Schritt*100/Rechnungen,Restzeit)
    end
end  
clc
end

map('xIxFx')=map_xIxFx;
map('xIxFy')=map_xIxFy;
map('x')=x_vec;
map('Ix')=Ix_vec;
map('yIyFy')=map_yIyFy;
map('yIyFx')=map_yIyFx;
map('y')=y_vec;
map('Iy')=Iy_vec;
end

%% Untersuchung des Fehlers in Abh. von virtual_Displacement Distanz
% mit Breakpoint in Schleife ausführen
    % for i=1:15
    % [~,Fy_Vector(i)] = self.calculate_force_Displace([posx_array(n),y], [I_vormag,I_vormag],[Ix_nutz_array(n1),Iy], 10^(-i))
    % end
    % figure(1),xlabel('Virtual Displacement'),ylabel('Fy Ergebnis')
    % loglog(10.^(-1:-1:-15),Fy_Vector)
    % figure(2),xlabel('Virtual Displacement'),ylabel('Fy Ergebnis')
    % semilogx(10.^(-5:-1:-13),Fy_Vector(5:13))