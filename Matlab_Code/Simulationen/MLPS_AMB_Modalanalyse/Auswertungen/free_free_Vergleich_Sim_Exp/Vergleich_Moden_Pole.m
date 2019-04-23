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
iPoles = [7,8;11,12;13,14;15,16];%[7,8,11,12,13,14,15,16];%
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
plot(Experiment.Positions,imag(Experiment.Vx(:,k)),'o-')
end
title('Experiment')

%plot der Modenformen in ein Bild:
Experiment.Vx(:,[2,3,4])=-Experiment.Vx(:,[2,3,4]);% Sensor.Vx(:,[2,3,4])=-Sensor.Vx(:,[2,3,4]);%sieht auf dem plot besser aus
for n=1:length(Sensor.p)
fig(n) = figure;
plot(Experiment.Positions,imag(Experiment.Vx(:,n)),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
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
figMAC=figure;
MAC=amac(-Experiment.Vx,Sensor.Vx);
plotmac(MAC,Experiment.p,Sensor.p')
xlabel('Simulation $f$/Hz','Interpreter','Latex');
ylabel('Experiment $f$/Hz','Interpreter','Latex');

figMACautoSim=figure;
MAC=amac(Sim.Vx);
plotmac(MAC,Sim.p)
xlabel('Simulation $f$/Hz','Interpreter','Latex');
ylabel('Simulation $f$/Hz','Interpreter','Latex');

figMACautoExp=figure;
MAC=amac(Experiment.Vx);
plotmac(MAC,Experiment.p)
xlabel('Experiment $f$/Hz','Interpreter','Latex');
ylabel('Experiment $f$/Hz','Interpreter','Latex');


Janitor.cleanFigures();

disp('Simulation Sensors')
SimZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Sensor.p,Sensor.Vx);

disp(' ')
disp('Experiment')
ExpZeroCrossing = get_sensor_mode_zero_crossing(Experiment.Positions,Experiment.p,imag(Experiment.Vx));



%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim.
ntmp=n;
% Sim.Vx(:,[2:3,4])=-Sim.Vx(:,[2:3]);%sieht auf dem plot besser aus
for n=1:length(Sim.p)
fig(ntmp+n) = figure;
plot(Experiment.Positions,imag(Experiment.Vx(:,n)),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
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


%% MAC-figure speichern
% lade TUM-Farben
TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);
filenameTikzMAC = 'tikz/MAC.tikz';
% filenameTikzModes{k} = ['Mode',num2str(k),'.tikz'];

set(0, 'currentfigure', figMAC);
zlim([0 1])
view(3)

% Exportiere zu tikz
% matlab2tikz(filenameTikzMAC, 'height', '\fheight', 'width', '\fwidth' )

% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzMAC, to_find, to_replace)

% export 2 pdf
FontSize=12;
FontName='Helvetica';

ax = gca;
ax.Title.String='';
figMAC.Units='normalized';
figMAC.Position(3:4) = [0.32, 0.35];%[0.2 0.2];
ax.Units = 'Centimeters';
ax.Position(3:4) = [10,8];
set(ax,'FontName',FontName,'FontSize',FontSize)
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC,regexprep(filenameTikzMAC,'.tikz',''),'-dpng','-r400');


set(0, 'currentfigure', figMAC);
view(-30,70) % Ansicht von weiter oben
filenameTikzMAChoch = [regexprep(filenameTikzMAC,'.tikz',''),'hoch.tikz'];
% Exportiere zu tikz
% matlab2tikz(filenameTikzMAChoch, 'height', '\fheight', 'width', '\fwidth' )

% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzMAChoch, to_find, to_replace)


% export 2 pdf
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC,regexprep(filenameTikzMAChoch,'.tikz',''),'-dpng','-r400');

%% Mode-comparison-figures speichern
numModes=4;
x_scale_factor=1000;
y_scale_factor=1000;
z_scale_factor=1000;
for kMode=1:numModes
    kFig = numModes+kMode;
    
filenameTikzModes{kMode} = ['tikz/Mode',num2str(kMode),'.tikz'];

set(0, 'currentfigure', fig(kFig));
ax = gca;
axObjs = fig(kFig).Children;
ax.XLim=ax.XLim*x_scale_factor;
ax.YLim=ax.YLim*y_scale_factor;
ax.ZLim=ax.ZLim*z_scale_factor;

axObjs.Children;
dataObjs=ans;

for j=1:length(dataObjs)
    dataObjs(j).XData = dataObjs(j).XData*x_scale_factor;
    dataObjs(j).YData = dataObjs(j).YData*y_scale_factor;
    dataObjs(j).ZData = dataObjs(j).ZData*z_scale_factor;
end
yticks(0)
xticks([113,623])
xticklabels({'ML L','ML R'})
grid on

% Farben aendern
for j=1:3 %MLright,MLleft,Nulllinie
    dataObjs(j).Color = grau;
    delete(dataObjs(j));
end
dataObjs(4).Color = 'black'; %Simulation
dataObjs(4).LineWidth = 1.5;
dataObjs(5).Color = TUMblue; %Experiment
dataObjs(5).LineWidth = 1.5;

ax.Title.String='';
xlabel('')%xlabel('$z$/mm','Interpreter','Latex')
ylabel('')%ylabel('$u$/mm','Interpreter','Latex')

% Exportiere zu tikz
matlab2tikz(filenameTikzModes{kMode}, 'height', '\fheight', 'width', '\fwidth' )

% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzModes{kMode}, to_find, to_replace)
to_find = '\\addlegendentry{Nulllinie';
to_replace = '\%\\addlegendentry{Nulllinie';
find_and_replace(filenameTikzModes{kMode}, to_find, to_replace)
to_find = '\\addlegendentry{MLleft';
to_replace = '\%\\addlegendentry{MLleft';
find_and_replace(filenameTikzModes{kMode}, to_find, to_replace)
to_find = '\\addlegendentry{MLright';
to_replace = '\%\\addlegendentry{MLright';
find_and_replace(filenameTikzModes{kMode}, to_find, to_replace)

%gar keine Legende anzeigen:
to_find = '\\addlegendentry{';
to_replace = '\%\\addlegendentry{';
find_and_replace(filenameTikzModes{kMode}, to_find, to_replace)

end