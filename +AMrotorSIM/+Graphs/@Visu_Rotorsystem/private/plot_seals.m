function plot_seals(ax,seal,obj)
% Provides/drafts the component seal for the visualization of the rotor system
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter seal: Object of type components (obj.rotorsystem.components)
%    :type seal: object
%    :parameter obj: Object of type rotor (obj.rotorsystem.rotor)
%    :type obj: object
%    :return: 3D model of the seal for 3D-visualization

% Licensed under GPL-3.0-or-later, check attached LICENSE file

for i=seal
    zp=i.cnfg.position;
    
    seal_pos = i.position; 
    node_at_pos = obj.find_node_nr(seal_pos);
    diameter = obj.mesh.nodes(node_at_pos).radius_outer*2;


    
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.1/2);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor',i.color)

end