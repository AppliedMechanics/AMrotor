function plot_unbalance(ax,load)
 % Visualization parameters setting -----------------------------
    color = AMrotorTools.TUMColors.TUMDiag1;
    
    if ~isfield(load.cnfg,'color')
    elseif isempty(load.cnfg.color)
    else
        color = load.cnfg.color;
    end
    
    width = load.cnfg.betrag*1000;
    if ~isfield(load.cnfg,'width')
    elseif isempty(load.cnfg.width)
    else
        width=load.cnfg.width;
    end
    
    length= 0.15;
    if ~isfield(load.cnfg,'length')
    elseif isempty(load.cnfg.length)
    else
        length=load.cnfg.length;
    end
    
    zp=load.cnfg.position;
    phi = load.cnfg.winkellage;
    
    r = width;
    xp = length*cos(phi);
    yp = length*sin(phi);
    % Kugel;
    [x,y,z] = sphere();
    h = surf(ax, z*r+zp, y*r+yp, x*r+xp);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)
    
    % Linie;
    h=line(ax, [zp,zp], [0,yp],[0,xp]);
    h.Color=color;
    h.LineWidth = 1;
end