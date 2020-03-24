function plot_force(ax,load)

    zp=load.cnfg.position;
    lx = load.cnfg.betrag_x;
    ly = load.cnfg.betrag_y;
    
    %Vektoren;
    h=quiver3(ax,zp,0,0,0,ly*0.004,lx*0.004);
    % Linie;
    
    h.Color='blue';
    h.LineWidth = 5;
    
    zp=load.cnfg.position;
    
    pos = load.position; 
    node_at_pos = obj.find_node_nr(pos);
    diameter = obj.mesh.nodes(node_at_pos).radius_outer*2;
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.2);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor','cyan')
end