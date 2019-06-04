% ToDo: noch Experiment laden fuer Vergleich
clear, close all

Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

Exp5000=importdata('Exp_Modes_supp_P5000.mat');
Exp3000=importdata('Exp_Modes_supp_P3000.mat');
Exp3000.p=Exp3000.p([1,2,2,3,4]); % Damit auch hier 5 Moden
Exp3000.Vx=Exp3000.Vx(:,[1,2,2,3,4]);
Sim5000=importdata('Simulation_Modes_supported_P5000.mat');
Sensor5000=importdata('Simulation_Modes_supported_Sensors_P5000.mat');
Sim3000=importdata('Simulation_Modes_supported_P3000.mat');
Sensor3000=importdata('Simulation_Modes_supported_Sensors_P3000.mat');

scaleFactorSim=10;

% Experiment
disp('EXPERIMENT P=5000')
listpoles(Exp5000.p)
disp('EXPERIMENT P=3000')
listpoles(Exp3000.p)

disp(' ')

% Simulation
iPoles = [1,2;4,5;6,7;9,10;12,13];
for k=1:size(iPoles,1)
    if Sim5000.Vx(:,iPoles(k,1))>Sim5000.Vx(:,iPoles(k,2))
        indexPoles(k) = iPoles(k,1);
    else
        indexPoles(k) = iPoles(k,2);
    end
end
clear iPoles
Sim5000.p = Sim5000.p(indexPoles);
Sim5000.Vx = Sim5000.Vx(:,indexPoles);
Sensor5000.p = Sensor5000.p(indexPoles);
Sensor5000.Vx = Sensor5000.Vx(:,indexPoles);

disp('SIMULATION P=5000')
listpoles(Sim5000.p)

disp(' ')

% Simulation P=3000
iPoles = [1,2;4,5;6,7;9,10;11,12];
for k=1:size(iPoles,1)
    if Sim3000.Vx(:,iPoles(k,1))>Sim3000.Vx(:,iPoles(k,2))
        indexPoles(k) = iPoles(k,1);
    else
        indexPoles(k) = iPoles(k,2);
    end
end
clear iPoles
Sim3000.p = Sim3000.p(indexPoles);
Sim3000.Vx = Sim3000.Vx(:,indexPoles);
Sensor3000.p = Sensor3000.p(indexPoles);
Sensor3000.Vx = Sensor3000.Vx(:,indexPoles);
disp('SIMULATION P=3000')
listpoles(Sim3000.p)

disp(' ')


%Vergleich von Eigenwerten
disp('P=5000, left=Experiment, right=Simulation')
listpoles(Exp5000.p,Sim5000.p)
disp('P=3000, left=Experiment, right=Simulation')
listpoles(Exp3000.p,Sim3000.p)

%plot der Modenformen
figure
hold on
for k=1:length(Sim5000.p)
plot(Sim5000.Positions,Sim5000.Vx(:,k),'-')
end
title('Simulation P=5000')

figure
hold on
for k=1:length(Sim3000.p)
plot(Sim3000.Positions,Sim3000.Vx(:,k),'-')
end
title('Simulation P=3000')

figure
hold on
for k=1:length(Exp5000.p)
plot(Exp5000.Positions,Exp5000.Vx(:,k),'o-')
end
title('Experiment P=5000')

figure
hold on
for k=1:length(Exp3000.p)
plot(Exp3000.Positions,Exp3000.Vx(:,k),'o-')
end
title('Experiment P=3000')

%plot der Modenformen in ein Bild:
Sensor5000.Vx(:,[2,3])=-Sensor5000.Vx(:,[2,3]);%sieht auf dem plot besser aus
for n=1:length(Sensor5000.p)
fig(n) = figure;
plot(Exp5000.Positions,Exp5000.Vx(:,n),'o-','DisplayName',['Exp.5000, ',num2str(imag(Exp5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp5000.p(n))/imag(Exp5000.p(n))*100,2),'%'])
hold on
plot(Sensor5000.Positions,scaleFactorSim*Sensor5000.Vx(:,n),'o-','DisplayName',['Sim.5000, ',num2str(imag(Sensor5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sensor5000.p(n))/imag(Sensor5000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
grid on
legend('show')
xlabel('z [m]')
title(['P=5000, Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end

% Vergleich der Eigenformen
figure
MAC=amac(Exp5000.Vx,Sensor5000.Vx);
plotmac(MAC,Exp5000.p,Sensor5000.p')
xlabel('Simulation5000')
ylabel('Experiment5000')

%plot der Modenformen in ein Bild:
Sensor3000.Vx(:,[2,3])=-Sensor3000.Vx(:,[2,3]);%sieht auf dem plot besser aus
for n=1:length(Sensor3000.p)
fig(n) = figure;
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o-','DisplayName',['Exp.3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])
hold on
plot(Sensor3000.Positions,scaleFactorSim*Sensor3000.Vx(:,n),'o-','DisplayName',['Sim.3000, ',num2str(imag(Sensor3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sensor3000.p(n))/imag(Sensor3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
grid on
legend('show')
xlabel('z [m]')
title(['P=3000, Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end

% Vergleich der Eigenformen
figure
MAC=amac(Exp3000.Vx(:,[1,2,4,5]),Sensor3000.Vx);
plotmac(MAC,Exp3000.p([1,2,4,5]),Sensor3000.p')
xlabel('Simulation3000')
ylabel('Experiment3000')

Janitor.cleanFigures();

% disp('Simulation Sensors')
% SimZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Sensor.p,Sensor.Vx);
% 
% disp(' ')
% disp('Experiment')
% ExpZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Experiment.p,Experiment.Vx);



%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim.
ntmp=0;
% ntmp=n;
Sim3000.Vx(:,[2:3])=-Sim3000.Vx(:,[2:3]);%sieht auf dem plot besser aus
for n=1:length(Sim5000.p)
fig(ntmp+n) = figure;
% plot(Sensor.Positions,Experiment.Vx(:,n),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
hold on
plot(Sim5000.Positions,scaleFactorSim*Sim5000.Vx(:,n),'-','DisplayName',['Sim5000, ',num2str(imag(Sim5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim5000.p(n))/imag(Sim5000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
plot(Sim3000.Positions,scaleFactorSim*Sim3000.Vx(:,n),'-','DisplayName',['Sim3000, ',num2str(imag(Sim3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim3000.p(n))/imag(Sim3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
plot(Exp5000.Positions,Exp5000.Vx(:,n),'o-','DisplayName',['Exp5000, ',num2str(imag(Exp5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp5000.p(n))/imag(Exp5000.p(n))*100,2),'%'])
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o-','DisplayName',['Exp3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])
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

% disp('Simulation all nodes')
% SimZeroCrossing = get_sensor_mode_zero_crossing(Sim.Positions,Sim.p,Sim.Vx);