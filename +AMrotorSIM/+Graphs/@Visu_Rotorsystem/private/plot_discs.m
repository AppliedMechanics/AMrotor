function plot_discs(ax,discs)

for disc=discs
    if isempty(disc.cnfg.color)
        disc.cnfg.color='yellow';
    end
    
    zp=disc.cnfg.position;
    r=disc.cnfg.radius;

    % %Scheiben;
    theta = linspace(0,2*pi,20);
    rs = linspace(0,r,2);
    
    % Visualization parameters setting -----------------------------
    if isempty(disc.cnfg.width)
        width = 0;
    else
        width = disc.cnfg.width;
    end
 
    [TH,R] = meshgrid(theta,rs);
    [x,y] = pol2cart(TH,R);
    z=(width/2).*cos(TH)-(width/2).*sin(TH);
    
    h=surf(ax,z+zp,y,x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',disc.cnfg.color)

    % Zylinderfl‰che auﬂenrum;
    [x,y,z] = cylinder(r);

    h = surf(ax, z*width+zp-width/2, y, x);
    set(h, 'edgecolor',[0.01 0.01 0.01])
    set(h, 'facecolor',disc.cnfg.color)

end





