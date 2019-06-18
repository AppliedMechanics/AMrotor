function Sensor = get_sensor_eigenmodes(esf)
% struct mit eigenvektoren des Systems an den Sensorspositionen zum
% vergleich mit dem Experiment

% Sensor.p = esf.modalsystem.eigenValues.lateral;
% Sensor.Vy=esf.modalsystem.eigenVectors.Sensor.lat_y;
% Sensor.Vx=esf.modalsystem.eigenVectors.Sensor.lat_x;
% Sensor.Positions = NaN(size(esf.modalsystem.rotorsystem.sensors));
% for k=1:length(Sensor.Positions)
%     Sensor.Positions(k) = esf.modalsystem.rotorsystem.sensors(k).Position;
% end
Sensor.p = esf.modalsystem.eigenValues.lateral;
EVy=esf.modalsystem.eigenVectors.Sensor.lat_y;
EVx=esf.modalsystem.eigenVectors.Sensor.lat_x;
Sensor.Positions = NaN(size(esf.modalsystem.rotorsystem.sensors));
for k=1:length(Sensor.Positions)
    Sensor.Positions(k) = esf.modalsystem.rotorsystem.sensors(k).Position;
end

% Transformiere in hauptachsensystem, vgl. plot_displacements.m
for s=1:length(Sensor.p)
    angle = atan2(real(EVy(:,s)),real(EVx(:,s)));
    angle = wrapTo2Pi(angle);
    % wrap angle to [0 pi]
    for i = 1:length(angle)
        if angle(i) > pi
            angle(i) = angle(i)-pi;
        end
    end
    angle = mean(angle);
    
    EVmain(:,s) = EVx(:,s)*cos(angle) + EVy(:,s)*sin(angle);
end
Sensor.Vx = EVmain;

% get zero crossing
figure
for s=1:length(Sensor.p)
    hold off
    plot(Sensor.Positions,real(EVmain(:,s)))
    hold on
    grid on
    zeroCrossing=[];
    for k=2:length(EVmain(:,s))
        amp=real(EVmain(k-1:k,s));
        pos=Sensor.Positions(k-1:k);
        x0 = interp1(amp,pos,0); % zero crossing
        zeroCrossing = [zeroCrossing, x0(~isnan(x0))];
    end
    plot(zeroCrossing,zeros(size(zeroCrossing)),'o')
    drawnow
    pause(0.1)
    Sensor.zero_crossing{s} = zeroCrossing;
end

% print zero crossing
disp(' ')
disp('Zero crossing of Sensor-modes')
for s=1:length(Sensor.p)
    disp(['Mode ',num2str(s),' ',num2str(imag(Sensor.p(s))/2/pi,3),'Hz',': ',num2str(Sensor.zero_crossing{s}*1e3,3),' mm']);
end
end