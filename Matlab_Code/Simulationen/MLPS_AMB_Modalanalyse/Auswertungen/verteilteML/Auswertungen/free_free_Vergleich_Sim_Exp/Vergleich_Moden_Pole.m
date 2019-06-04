clear, close all

Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

load('Experiment_Modes_free_free_Sensors.mat')
load('Simulation_Modes_free_free_Sensors.mat') % enthaelt die Moden an den Sensorpositionen
load('Simulation_Modes_free_free.mat') % enthaelt die Moden an allen Knoten

% Experiment
disp('EXPERIMENT')
listpoles(Experiment.p)

disp(' ')

% Simulation
iPoles = [7,8;10,11;13,14;15,16];%[7,8,11,12,13,14,15,16];%
for k=1:size(iPoles,1)
    if Sensor.Vx(:,iPoles(k,1))>Sensor.Vx(:,iPoles(k,2))
        indexPoles(k) = iPoles(k,1);
    else
        indexPoles(k) = iPoles(k,2);
    end
end
clear iPoles
Sensor.p = Sensor.p(indexPoles);
Sensor.Vx = Sensor.Vx(:,indexPoles);
Sim.p = Sim.p(indexPoles);
Sim.Vx = Sim.Vx(:,indexPoles);
disp('SIMULATION')
listpoles(Sensor.p)

disp(' ')

%Vergleich von Eigenwerten
% Sensor.EF = imag(Sensor.p(:,1))/2/pi;
% Experiment.EF = Experiment.p/2/pi;
% Sensor.Damp = -real(Sensor.p(:,1))./imag(Sensor.p(:,1));
% Experiment.Damp = -real(Experiment.p)./imag(Experiment.p);
% Delta.EF = Sensor.EF-Experiment.EF;
% DeltaRelative.EF = Delta.EF/Experiment.EF; %bezogen auf Experiment;
% Delta.Damp = Sensor.Damp-Experiment.Damp;
% DeltaRelative.Damp = Delta.Damp/Experiment.Damp;
% fprintf('Abwichung zwischen Simulation und Experiment \n');
% fprintf('Natural Freq. [%%]    Damping [%%]\n')
% fprintf('---------------------------------\n')
% fprintf('%20s%20s%20s\n','Natural Frequencies [Hz]','Damping [%]','Difference [%]');
listpoles(Experiment.p,Sensor.p')

%plot der Modenformen
figure
hold on
for k=1:length(Sensor.p)
plot(Sensor.Positions,Sensor.Vx(:,k),'o-')
end
title('Simulation')

figure
hold on
for k=1:length(Experiment.p)
plot(Sensor.Positions,Experiment.Vx(:,k),'o-')
end
title('Experiment')

%plot der Modenformen in ein Bild:
% Experiment.Vx(:,[2,3,4])=-Experiment.Vx(:,[2,3,4]);% Sensor.Vx(:,[2,3,4])=-Sensor.Vx(:,[2,3,4]);%sieht auf dem plot besser aus
for n=1:length(Sensor.p)
fig(n) = figure;
plot(Sensor.Positions,Experiment.Vx(:,n),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
hold on
plot(Sensor.Positions,Sensor.Vx(:,n),'o-','DisplayName',['Sim., ',num2str(imag(Sensor.p(n))/2/pi,3),'Hz, ',num2str(-real(Sensor.p(n))/imag(Sensor.p(n))*100,2),'%'])
grid on
legend('show')
xlabel('z [m]')
title(['Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end


% Vergleich der Eigenformen
figure
MAC=amac(Experiment.Vx,Sensor.Vx);
plotmac(MAC,Experiment.p,Sensor.p')
xlabel('Simulation')
ylabel('Experiment')

Janitor.cleanFigures();

disp('Simulation Sensors')
SimZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Sensor.p,Sensor.Vx);

disp(' ')
disp('Experiment')
ExpZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Experiment.p,Experiment.Vx);



%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim.
ntmp=n;
% Sim.Vx(:,[2:3,4])=-Sim.Vx(:,[2:3]);%sieht auf dem plot besser aus
for n=1:length(Sim.p)
fig(ntmp+n) = figure;
plot(Sensor.Positions,Experiment.Vx(:,n),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
hold on
plot(Sim.Positions,Sim.Vx(:,n),'-','DisplayName',['Sim., ',num2str(imag(Sim.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim.p(n))/imag(Sim.p(n))*100,2),'%'])
% plot(Sensor.Positions,Sensor.Vx(:,n),'o-','DisplayName',['Sim., ',num2str(imag(Sensor.p(n))/2/pi,3),'Hz, ',num2str(-real(Sensor.p(n))/imag(Sensor.p(n))*100,2),'%'])
grid on
legend('show')
xlabel('z [m]')
title(['Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black','DisplayName','Nulllinie') %Nulllinie
ylim(ylim); % y-limits feststellen
plot([1 1]*113e-3,ylim,'k','DisplayName','MLleft')
plot([1 1]*623e-3,ylim,'k','DisplayName','MLright')
xlim([0, 0.702])
end

Janitor.cleanFigures();

disp('Simulation all nodes')
SimZeroCrossing = get_sensor_mode_zero_crossing(Sim.Positions,Sim.p,Sim.Vx);