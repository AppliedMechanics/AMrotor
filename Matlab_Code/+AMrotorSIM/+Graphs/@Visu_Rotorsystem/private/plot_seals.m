function plot_seals(ax,seal,obj)

for i=seal
    zp=i.cnfg.position;
    
    seal_pos = i.position; 
    node_at_pos = obj.find_node_nr(seal_pos);
    diameter = obj.mesh.nodes(node_at_pos).radius*2;


    
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.1/2);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,x, y,z*0.01+zp );

    set(h, 'edgecolor','none')
    set(h, 'facecolor',i.color)

end