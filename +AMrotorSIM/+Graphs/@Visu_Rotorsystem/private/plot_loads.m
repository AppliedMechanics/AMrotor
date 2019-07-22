function plot_loads(ax,load,obj)

for i=load
    if isa(i,'AMrotorSIM.Loads.Unbalance_static')
    zp=i.cnfg.position;
    r = i.cnfg.betrag*0.01;
    phi = i.cnfg.winkellage;
    
    R = 0.15;
    xp = R*cos(phi);
    yp = R*sin(phi);
    % Kugel;
    [x,y,z] = sphere();
    h = surf(ax, z*r+zp, y*r+yp, x*r+xp);

    % Linie;
    line(ax, [zp,zp], [0,yp],[0,xp]);
    
    set(h, 'edgecolor','none')
%    set(h, 'facecolor',i.cnfg.color)
    elseif isa(i,'AMrotorSIM.Loads.Force_constant_fix')
    zp=i.cnfg.position;
    lx = i.cnfg.betrag_x;
    ly = i.cnfg.betrag_y;
    
    %Vektoren;
    h=quiver3(ax,zp,0,0,0,ly*0.004,lx*0.004);
    % Linie;
    
    h.Color='blue';
    h.LineWidth = 5;
    else
    
    zp=i.cnfg.position;
    
    pos = i.position; 
    node_at_pos = obj.find_node_nr(pos);
    diameter = obj.mesh.nodes(node_at_pos).radius_outer*2;
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.2);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor','cyan')
    end
end