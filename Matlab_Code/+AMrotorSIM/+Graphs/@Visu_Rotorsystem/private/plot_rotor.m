function [ax] = plot_rotor(rotor)

nodes = rotor.nodes;
rotorpar = rotor.cnfg;
% das ist eine Funktion die zu jedem Element des Rotors einen zylinder erzeugt 

a=1;
n=1;
dimR=size(rotorpar.rotor_dimensions);
n_nodes=length(nodes);

r=zeros(n_nodes,1);
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

ax = axes('xlim', [-10 10], 'ylim', [-10 10], 'zlim',[-10 10]);
set(gcf,'Name','Visualisierung Rotorsystem','NumberTitle','off')

view(160,-30);
grid off;
axis equal;
hold on
set(gca, 'visible', 'off'); 

dim_r=size(r);


theta = linspace(0,2*pi,20);

k=1;

%%%%%%%%%%%%%%%%%%%%%%%
%erstes el
rs = linspace(0,r(1),2);
% 
 [TH,R] = meshgrid(theta,rs);
% 
 Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
% 
 [x,y,z] = pol2cart(TH,R,Z);
 
 z=z*0;

hs(1)=surf(z+nodes(1),y,x);
%hs(1)=surf(x,y,z+nodes(1));
set(hs(1), 'edgecolor','none')
set(hs(1), 'facecolor','b')
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
 [x,y,z] = pol2cart(TH,R,Z);
 
 z=z*0;


%plote Zylinder
%hz(n) = surf(xzyl,yzyl,zzyl);
hz(n) = surf(zzyl,yzyl,xzyl);
set(hz(n), 'edgecolor','none')
set(hz(n), 'facecolor','b')
%Plote Deckel
hs(n)=surf(z+nodes(n),y,x);
%hs(n)=surf(x,y,z+nodes(n));
set(hs(n), 'facecolor','b')

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

zz=1:50;

% shows axis system for reference
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),[0.1;0;0],[0;0.1;0],[0;0;0.1],'k')
text(0.1,0.0,0.0,'z')
text(0.0,0.1,0.0,'y')
text(0.0,0.0,0.1,'x')
end





