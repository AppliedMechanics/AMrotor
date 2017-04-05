function plot_bearings(ax,bearing)

for i=bearing
    zp=i.cnfg.position;

    % Zylinderfläche;
    [x,y,z] = cylinder(0.05);

    h = surf(ax, x, y, z*0.01+zp);

    set(h, 'edgecolor','none')
    set(h, 'facecolor','[1 .5 0]')

end