function plot_unbalance(ax,load)
 % Visualization parameters setting -----------------------------
    color = AMrotorTools.TUMColors.TUMDiag13;
    
    if ~isfield(load.cnfg,'color')
    elseif isempty(load.cnfg.color)
    else
        color = load.cnfg.color;
    end
    
    width = 2;
    if ~isfield(load.cnfg,'width')
    elseif isempty(load.cnfg.width)
    else
        width=load.cnfg.width;
    end
    
    length= 0.1;
    if ~isfield(load.cnfg,'length')
    elseif isempty(load.cnfg.length)
    else
        width=load.cnfg.length;
    end
    
    zp=load.cnfg.position;
    r = load.cnfg.betrag*0.01;
    phi = load.cnfg.winkellage;
    
    R = 0.15;
    xp = R*cos(phi);
    yp = R*sin(phi);
    % Kugel;
    [x,y,z] = sphere();
    h = surf(ax, z*r+zp, y*r+yp, x*r+xp);

    % Linie;
    line(ax, [zp,zp], [0,yp],[0,xp]);
    
    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)
    %h.Color=color;
    %h.LineWidth = width;
end