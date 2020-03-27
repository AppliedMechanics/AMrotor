function plot_bearing(ax,bearing,obj)
      
    zp=bearing.cnfg.position;    
    bearing_pos = bearing.position; 
    node_at_pos = obj.find_node_nr(bearing_pos);

    % Visualization parameters setting -----------------------------
    color = AMrotorTools.TUMColors.TUMOrange;
    
    if ~isfield(bearing.cnfg,'color')
    elseif isempty(bearing.cnfg.color)
    else
        color = bearing.cnfg.color;
    end
    
    width = 10e-3;
    if ~isfield(bearing.cnfg,'width')
    elseif isempty(bearing.cnfg.width)
    else
        width = bearing.cnfg.width;
    end
    
    radius = obj.mesh.nodes(node_at_pos).radius_outer*1.4;
    if ~isfield(bearing.cnfg,'vradius')
    elseif isempty(bearing.cnfg.vradius)
    else
        radius = bearing.cnfg.vradius;
    end
    % -------------------------------------------------------------
    
    % Drawing the graph -------------------------------------------
    [x,y,z] = cylinder(radius);

    h = surf(ax,z*width+zp-width/2, y, x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)

end