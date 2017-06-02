



% vx=[0 0 2*0.015 3*0.015 4*0.015 5*0.015 6*0.015 7*0.015 8*0.015 7*0.015 6*0.015 5*0.015 4*0.015 3*0.015 2*0.015 1*0.015 0 ]*0.5;





% function [n] = plot_rotor_geometry(nodes,rotorpar)

% das ist eine Funktion die zu jedem Element des Rot0rs einen zylinder
% erzeugt 

V=10;
a=1;
n=1;
dimR=size(rotorpar.rotor_dimensions);
n_nodes=length(nodes);


lb=10; % lagerbreite

xL=0;
yL=0;
zL=-15/2;


r=zeros(n_nodes,1);
dim_r=size(r);
% erzeuge Vektor r mit Radien der Abschnitte
%==========================================================================
for k=1:n_nodes

while nodes(n) <= rotorpar.rotor_dimensions(a,1) && n <n_nodes
    
    r(n,1)=rotorpar.rotor_dimensions(a,2);
    
    n=n+1;
    
end

if a < dimR(1)
a=a+1;
end

end

 r(end)=rotorpar.rotor_dimensions(end,2);
%==========================================================================








% axis equal
%  myaxes = axes('xlim', [-10 10], 'ylim', [-10 10], 'zlim',[-10 10]);


 
% 
myaxes = axes('xlim', [-0.100 0.700], 'ylim', [-0.3 0.30], 'zlim',[-0.3 0.3]);
view(3);
grid on;
% axis equal;
hold on
xlabel('z')
ylabel('y')
zlabel('x')


Lr=rotorpar.rotor_dimensions(end,1)*1e3;


theta = linspace(0,2*pi,20);

k=1;

pt1=[xL+lb yL-lb zL-lb*5]*1e-3; pt2=[xL+lb yL+lb zL-lb*5]*1e-3; pt3=[xL-lb yL+lb zL-lb*5]*1e-3; pt4=[xL-lb yL-lb zL-lb*5]*1e-3; pt5=[xL yL zL]*1e-3;
P = [pt1; pt2; pt3; pt4; pt5];
ind = [1 2 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
% hold on

ind = [2 3 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
ind = [3 4 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')
ind = [4 1 5]; patch(P(ind, 1), P(ind, 2), P(ind, 3), 'r')


pr1=[xL+lb+Lr yL-lb zL-lb*5]*1e-3; pr2=[xL+lb+Lr yL+lb zL-lb*5]*1e-3; pr3=[xL-lb+Lr yL+lb zL-lb*5]*1e-3; pr4=[xL-lb+Lr yL-lb zL-lb*5]*1e-3; pr5=[xL+Lr yL zL]*1e-3;
Pr = [pr1; pr2; pr3; pr4; pr5];
ind = [1 2 5]; patch(Pr(ind, 1), Pr(ind, 2), Pr(ind, 3), 'r')

ind = [2 3 5]; patch(Pr(ind, 1), Pr(ind, 2), Pr(ind, 3), 'r')
ind = [3 4 5]; patch(Pr(ind, 1), Pr(ind, 2), Pr(ind, 3), 'r')
ind = [4 1 5]; patch(Pr(ind, 1), Pr(ind, 2), Pr(ind, 3), 'r')
% ind = 1:4;  patch(P(ind, 1), P(ind, 2), zeros(1,4), 'b')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for t=8000:30:length(T)




vx=x(:,t)*V;

vy=y(:,t)*V;


rs = linspace(0,r(1),2);
% 
 [TH,R] = meshgrid(theta,rs);
% 
 Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
% 
 [xs,ys,zs] = pol2cart(TH,R,Z);
 
 zs=zs*0;

hs(1)=surf(zs+nodes(1),ys+vy(1),xs+vx(1));
set(hs(1), 'edgecolor','none')
set(hs(1), 'facecolor','g')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for n=2:dim_r(1)

 %Berechnen der Zylinderelemente   
[xzyl, yzyl, zzyl] = cylinder([r(n) r(n)]);




zzyl(1,:)=nodes(n-1);

zzyl(2,:)=nodes(n);




%% berechenen der Scheiben bzw Zyl. Deckel :-))


% 
  rs = linspace(0,r(n),2);
% 
 [TH,R] = meshgrid(theta,rs);
% 
 Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
% 
 [xs,ys,zs] = pol2cart(TH,R,Z);
 
 zs=zs*0;


%plote Zylinder


hz(n) = surf(zzyl,yzyl+vy(n), xzyl+vx(n));

set(hz(n), 'edgecolor','none')
set(hz(n), 'facecolor','b')


%Plote Deckel
hs(n)=surf(zs+nodes(n),ys+vy(n),xs+vx(n));

set(hs(n), 'facecolor','g')

if r(n) > r(n-1) 

set(hs(n), 'edgecolor','none') %sichtbare deckel ohne edges

end



if r(n) < r(n-1)

    set(hs(n-1), 'edgecolor','none')   %sichtbare deckel ohne edges
    
end




k=k+2;





end

set(hs(n), 'edgecolor','none')
set(hs(n), 'facecolor','b')

% clf(fig,'hs(:)','hz(:)')
pause(1e-9);

% set(hz,'visible','off')
% set(hs,'visible','off')

delete (hz)
delete(hs)
schleife=t

% hold off
end


