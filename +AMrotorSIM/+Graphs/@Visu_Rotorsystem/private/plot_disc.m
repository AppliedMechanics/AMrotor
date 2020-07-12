function plot_disc(ax,disc)

    zp=disc.cnfg.position;
    r=disc.cnfg.radius;

    % %Scheiben;
    theta = linspace(0,2*pi,20);
    rs = linspace(0,r,2);
    
    % Visualization parameters setting -----------------------------
    color = AMrotorTools.TUMColors.TUMBlue;
    
    if ~isfield(disc.cnfg,'color')
    elseif isempty(disc.cnfg.color)
    else
        color = disc.cnfg.color;
    end
    
    width=0;
    if ~isfield(disc.cnfg,'width')
    elseif isempty(disc.cnfg.width)
    else
        width = disc.cnfg.width;
    end
 
    % Plotting ---------------------------
    [TH,R] = meshgrid(theta,rs);
    [x,y] = pol2cart(TH,R);
    z=(width/2).*cos(TH)-(width/2).*sin(TH);
    
    h=surf(ax,z+zp,y,x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)

    % Zylinderfl�che au�enrum;
    [x,y,z] = cylinder(r);

    h = surf(ax, z*width+zp-width/2, y, x);
    set(h, 'edgecolor',[0.01 0.01 0.01])
    set(h, 'facecolor',color)

end




