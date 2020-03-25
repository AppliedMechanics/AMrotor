function plot_force(ax,load)

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
    
    xlength= 0.075;
    if ~isfield(load.cnfg,'xlength')
    elseif isempty(load.cnfg.xlength)
    else
        xlength=load.cnfg.xlength;
    end
    
    ylength= 0.075;
    if ~isfield(load.cnfg,'ylength')
    elseif isempty(load.cnfg.ylength)
    else
        ylength=load.cnfg.ylength;
    end
    
    radius = 0.005;
    if ~isfield(load.cnfg,'radius')
    elseif isempty(load.cnfg.radius)
    else
        ylength=load.cnfg.radius;
    end    

    zp=load.cnfg.position;
    
    %Vektoren;
    h=quiver3(ax,zp,-radius-ylength,-radius-xlength,0,ylength,xlength);
    h.Color = color;
    h.LineWidth = width;
    h.MaxHeadSize = 0.6;
    
    % Zylinderfläche;
    [x,y,z] = cylinder(radius);

    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)
end