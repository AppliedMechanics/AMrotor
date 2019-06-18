function plot_bearings(ax,bearing,obj)

for i=bearing
    zp=i.cnfg.position;
    
    bearing_pos = i.position; 
    node_at_pos = obj.find_node_nr(bearing_pos);
    diameter = obj.mesh.nodes(node_at_pos).radius_outer*2;


    
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.4);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor',i.color)

end