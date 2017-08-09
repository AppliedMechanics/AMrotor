function plot_bearings(ax,bearing,obj)

for i=bearing
    zp=i.cnfg.position;
    
    bearing_pos = bearing.position; 
    diameter = obj.get_diameter(bearing_pos);


    
    % Zylinderfläche;
    [x,y,z] = cylinder(diameter*1.4);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax, z*0.01+zp, y,x );

    set(h, 'edgecolor','none')
    set(h, 'facecolor',i.color)

end