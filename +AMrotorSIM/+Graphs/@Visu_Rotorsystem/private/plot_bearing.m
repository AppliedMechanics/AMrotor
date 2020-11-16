function plot_bearing(ax,bearing,obj)
% Provides/drafts the component bearing for the visualization of the rotor system
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter bearing: Object of type components (obj.rotorsystem.components)
%    :type bearing: object
%    :parameter obj: Object of type rotor (obj.rotorsystem.rotor)
%    :type obj: object
%    :return: 3D model of the bearing for 3D-visualization

% Licensed under GPL-3.0-or-later, check attached LICENSE file
      
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