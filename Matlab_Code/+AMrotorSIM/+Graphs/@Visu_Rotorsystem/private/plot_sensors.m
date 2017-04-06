function plot_sensors(ax,sensor)

for i=sensor
    if isa(i,'AMrotorSIM.Sensors.Wegsensor')
    zp=i.cnfg.position;
    
    %Vektoren;
    h=quiver3(ax,[0,0],[0,0],[zp,zp],[0.1,0],[0,0.1],[0,0]);
    % Linie;
    
    h.Color='cyan';
    h.LineWidth = 1;
    end
end