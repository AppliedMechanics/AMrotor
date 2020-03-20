function plot_discs(ax,discs)

for disc=discs
    zp=disc.position;
    r=disc.radius;
    w=disc.width;
    % %Scheiben;
    theta = linspace(0,2*pi,20);
    rs = linspace(0,r,2);
 
    [TH,R] = meshgrid(theta,rs);
    [x,y] = pol2cart(TH,R);
    z=(w/2).*cos(TH)-(w/2).*sin(TH);
    
    h=surf(ax,z+zp,y,x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',disc.color)

    % Zylinderfl‰che auﬂenrum;
     [x,y,z] = cylinder(r);

    h = surf(ax, z*w+zp-w/2,y ,x );
    set(h, 'edgecolor',[0.01 0.01 0.01])
    set(h, 'facecolor',disc.color)

end





