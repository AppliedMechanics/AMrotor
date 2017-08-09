function plot_loads(ax,load)

for i=load
    if isa(i,'AMrotorSIM.Loads.Unbalance_static')
    zp=i.cnfg.position;
    r = i.cnfg.betrag*0.01;
    phi = i.cnfg.winkellage;
    
    R = 0.3;
    xp = R*cos(phi);
    yp = R*sin(phi);
    % Kugel;
    [x,y,z] = sphere();
    %h = surf(ax, x*r+xp, y*r+yp, z*r+zp);
    h = surf(ax, z*r+zp, y*r+yp, x*r+xp); %Vertauschung x und z

    % Linie;
    line(ax,[0,xp], [0,yp], [zp,zp]);
    
    set(h, 'edgecolor','none')
    set(h, 'facecolor','r')
    end

    if isa(i,'AMrotorSIM.Loads.Force_constant_fix')
    zp=i.cnfg.position;
    lx = i.cnfg.betrag_x;
    ly = i.cnfg.betrag_y;
    
    %Vektoren;
    %h=quiver3(ax,0,0,zp,lx*0.003,ly*0.003,0);
    h=quiver3(ax,zp,0,0,lx*0.003,ly*0.003,0);
    % Linie;
    
    h.Color='green';
    h.LineWidth = 2;
    end
end