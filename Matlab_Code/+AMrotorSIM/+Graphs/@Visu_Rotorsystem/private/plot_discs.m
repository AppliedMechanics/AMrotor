function plot_discs(ax,discs)

for i=discs
    zp=i.cnfg.position;
    r=i.cnfg.radius;
    % %Scheiben;
%     theta = linspace(0,2*pi,20);
%     rs = linspace(0,r,2);
 
%     [TH,R] = meshgrid(theta,rs);
%     [x,y] = pol2cart(TH,R);
%     z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
%     h=surf(x,y,z+zp);
%     set(h, 'edgecolor','none')
%     set(h, 'facecolor','y')

    % Zylinderfläche;
    [x,y,z] = cylinder(r);

    h = surf(ax, x, y, z*0.01+zp);

    set(h, 'edgecolor','none')
    set(h, 'facecolor','y')

end





