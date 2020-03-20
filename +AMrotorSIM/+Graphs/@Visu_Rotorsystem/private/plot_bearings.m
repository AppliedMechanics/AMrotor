function plot_bearings(ax,bearings,obj)

for bearing=bearings
    
    if isempty(bearing.cnfg.color)
        bearing.cnfg.color='green';
    end
    
    zp=bearing.cnfg.position;
        
    bearing_pos = bearing.position; 
    node_at_pos = obj.find_node_nr(bearing_pos);

    % Visualization parameters setting -----------------------------
    if xor(~isfield(bearing.cnfg,'width'),isempty(bearing.cnfg.width))
        width = 10e-3;
    else 
        width = bearing.cnfg.width;
    end
    
    if ~isfield(bearing.cnfg,'vradius')
        radius = obj.mesh.nodes(node_at_pos).radius_outer*1.4;
    elseif isempty(bearing.cnfg.vradius)
        radius = bearing.cnfg.vradius;
    end
    % -------------------------------------------------------------
    
    % Drawing the graph -------------------------------------------
    [x,y,z] = cylinder(radius);

    h = surf(ax,z*width+zp-width/2, y, x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',bearing.cnfg.color)

end