
clear, close all

FontSize=12;
FontSizeAx=10;
FontName='Helvetica';

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

%plot der Modenformen in ein Bild P=5000:
% Sensor5000.Vx(:,[2,3])=-Sensor5000.Vx(:,[2,3]);%sieht auf dem plot besser aus
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
%plot der Modenformen in ein Bild mit Simulation P=5000:
for n=1:length(Sensor5000.p)
fig5000(n) = figure;
plot(Exp5000.Positions,Exp5000.Vx(:,n),'o-','DisplayName',['Exp.5000, ',num2str(imag(Exp5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp5000.p(n))/imag(Exp5000.p(n))*100,2),'%'])
hold on
plot(Sim5000.Positions,scaleFactorSim*Sim5000.Vx(:,n),'-','DisplayName',['Sim.5000, ',num2str(imag(Sim5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim5000.p(n))/imag(Sim5000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
grid on
legend('show')
xlabel('z [m]')
title(['P=5000, Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end


% Vergleich der Eigenformen mit MAC P=5000
figMAC5000=figure;
MAC=amac(Exp5000.Vx,Sensor5000.Vx);
plotmac(MAC,Exp5000.p,Sensor5000.p')
title('Cross-MAC P=5000')
xlabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)

figMAC5000autoSim=figure;
MAC=amac(Sim5000.Vx);
plotmac(MAC,Sim5000.p)
title('Auto-MAC P=5000 Sim')
xlabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)


figMAC5000autoExp=figure;
MAC=amac(Exp5000.Vx);
plotmac(MAC,Exp5000.p)
title('Auto-MAC P=5000 Exp')
xlabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)


%plot der Modenformen in ein Bild:
% Sensor3000.Vx(:,[2,3])=-Sensor3000.Vx(:,[2,3]);%sieht auf dem plot besser aus
for n=1:length(Sensor3000.p)
fig(n) = figure;
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o-','DisplayName',['Exp.3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])
hold on
plot(Sensor3000.Positions,scaleFactorSim*Sensor3000.Vx(:,n),'-','DisplayName',['Sim.3000, ',num2str(imag(Sensor3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sensor3000.p(n))/imag(Sensor3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
grid on
legend('show')
xlabel('z [m]')
title(['P=3000, Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end
%plot der Modenformen in ein Bild mit Simulation P=3000:
for n=1:length(Sensor3000.p)
fig(n) = figure;
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o-','DisplayName',['Exp.3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])
hold on
plot(Sim3000.Positions,scaleFactorSim*Sim3000.Vx(:,n),'-','DisplayName',['Sim.3000, ',num2str(imag(Sim3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim3000.p(n))/imag(Sim3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim)])
grid on
legend('show')
xlabel('z [m]')
title(['P=3000, Mode ',num2str(n)])
plot([0, 0.702],[0, 0],'black') %Nulllinie
xlim([0, 0.702])
end

% Vergleich der Eigenformen mit MAC P=3000
figMAC3000=figure;
MAC=amac(Exp3000.Vx(:,[1,2,4,5]),Sensor3000.Vx);
plotmac(MAC,Exp3000.p([1,2,4,5]),Sensor3000.p')
title('Cross-MAC P=3000')
xlabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)

figMAC3000autoSim=figure;
MAC=amac(Sim3000.Vx);
plotmac(MAC,Sim3000.p)
title('Auto-MAC P=3000 Sim')
xlabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Simulation $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)

figMAC3000autoExp=figure;
MAC=amac(Exp3000.Vx(:,[1,2,4,5]));
plotmac(MAC,Exp3000.p([1,2,4,5]))
title('Auto-MAC P=3000 Exp')
xlabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
ylabel('Experiment $f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)

Janitor.cleanFigures();

% disp('Simulation Sensors')
% SimZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Sensor.p,Sensor.Vx);
% 
% disp(' ')
% disp('Experiment')
% ExpZeroCrossing = get_sensor_mode_zero_crossing(Sensor.Positions,Experiment.p,Experiment.Vx);



%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim. P=5000
ntmp=0;
% ntmp=n;
% Sim3000.Vx(:,[2:3])=-Sim3000.Vx(:,[2:3]);%sieht auf dem plot besser aus
% scaleFactorSim=ones(size(Sim5000.p))*10;
scaleFactorSim=[18,-20,18,20,20];
for n=1:length(Sim5000.p)
fig5000(n) = figure;
% plot(Sensor.Positions,Experiment.Vx(:,n),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
plot(Exp5000.Positions,Exp5000.Vx(:,n),'o-','DisplayName',['Exp5000, ',num2str(imag(Exp5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp5000.p(n))/imag(Exp5000.p(n))*100,2),'%'])
hold on
plot(Sim5000.Positions,scaleFactorSim(n)*Sim5000.Vx(:,n),'-','DisplayName',['Sim5000, ',num2str(imag(Sim5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim5000.p(n))/imag(Sim5000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim(n))])
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

%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim. P=3000
ntmp=0;
% ntmp=n;
Sim3000.Vx(:,[2:3])=-Sim3000.Vx(:,[2:3]);%sieht auf dem plot besser aus
% scaleFactorSim=ones(size(Sim3000.p))*10;
scaleFactorSim=[-18,-20,18,10,20];
for n=1:length(Sim3000.p)
fig3000(n) = figure;
if n~=3
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o-','DisplayName',['Exp3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])   
end
hold on
plot(Sim3000.Positions,scaleFactorSim(n)*Sim3000.Vx(:,n),'-','DisplayName',['Sim3000, ',num2str(imag(Sim3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim3000.p(n))/imag(Sim3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim(n))])
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

%plot der Modenformen in ein Bild: Vgl. Exp. mit allen Knoten der Sim. P=5000
ntmp=0;
% ntmp=n;
% Sim3000.Vx(:,[2:3])=-Sim3000.Vx(:,[2:3]);%sieht auf dem plot besser aus
% scaleFactorSim=ones(size(Sim5000.p))*10;
scaleFactorSim=[18,-20,18,20,20];
direction5000=[1,1,1,1,1];
direction3000=[-1,1,-1,1,1];
for n=1:length(Sim5000.p)
figAllInOne(n) = figure;
% plot(Sensor.Positions,Experiment.Vx(:,n),'o-','DisplayName',['Exp., ',num2str(imag(Experiment.p(n))/2/pi,3),'Hz, ',num2str(-real(Experiment.p(n))/imag(Experiment.p(n))*100,2),'%'])
plot(Exp5000.Positions,Exp5000.Vx(:,n),'o-','DisplayName',['Exp5000, ',num2str(imag(Exp5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp5000.p(n))/imag(Exp5000.p(n))*100,2),'%'])
hold on
plot(Exp3000.Positions,Exp3000.Vx(:,n),'o--','DisplayName',['Exp3000, ',num2str(imag(Exp3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Exp3000.p(n))/imag(Exp3000.p(n))*100,2),'%'])
plot(Sim5000.Positions,direction5000(n)*scaleFactorSim(n)*Sim5000.Vx(:,n),'-','DisplayName',['Sim5000, ',num2str(imag(Sim5000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim5000.p(n))/imag(Sim5000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim(n))])
plot(Sim3000.Positions,direction3000(n)*scaleFactorSim(n)*Sim3000.Vx(:,n),'--','DisplayName',['Sim3000, ',num2str(imag(Sim3000.p(n))/2/pi,3),'Hz, ',num2str(-real(Sim3000.p(n))/imag(Sim3000.p(n))*100,2),'%',' scale',num2str(scaleFactorSim(n))])
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


%% MAC-figure speichern
% lade TUM-Farben
TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);
% filenameTikzModes{k} = ['Mode',num2str(k),'.tikz'];
filenameTikzMAC5000 = 'tikz/MAC5000.tikz';
set(0, 'currentfigure', figMAC5000);
zlim([0 1])
view(3)
% export 2 pdf
ax = gca;
ax.Title.String='';
ax.DataAspectRatio = [1 1 0.5];
XLabelPosition = ax.XLabel.Position;
YLabelPosition = ax.YLabel.Position;
view(-135,45)
ax.XLabel.Position=[2.4795 0.4269 -0.4247];
ax.YLabel.Position=[0.5247 2.2102 -0.5298];
set(ax,'FontName',FontName,'FontSize',FontSizeAx)
% figMAC5000.Units='centimeters';
% figMAC5000.Position(3:4) = [figMAC5000.Position(3:4)]*9/figMAC5000.Position(3);%[0.2 0.2];
figMAC5000.Units='normalized';
figMAC5000.Position(3:4) = [0.32, 0.35];%[0.2 0.2];
ax.Units = 'Centimeters';
ax.Position(3:4) = [10,8];
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC5000,regexprep(filenameTikzMAC5000,'.tikz',''),'-dpng','-r400');
figure(figMAC5000.Number)
% export_fig(regexprep(filenameTikzMAC5000,'.tikz',''),'-png','-transparent')
set(0, 'currentfigure', figMAC5000);
ax.XLabel.Position = XLabelPosition;
ax.YLabel.Position = YLabelPosition;
view(-30,70) % Ansicht von weiter oben
filenameTikzMAC5000hoch = [regexprep(filenameTikzMAC5000,'.tikz',''),'hoch.tikz'];
% export 2 pdf
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC5000,regexprep(filenameTikzMAC5000hoch,'.tikz',''),'-dpng','-r400');
figure(figMAC5000.Number)
% export_fig(regexprep(filenameTikzMAC5000,'.tikz',''),'-png','-transparent')


filenameTikzMAC3000 = 'tikz/MAC3000.tikz';
set(0, 'currentfigure', figMAC3000);
figure(figMAC3000.Number)
zlim([0 1])
view(3)
% export 2 pdf
FontSize=12;
FontName='Helvetica';
ax = gca;
ax.Title.String='';
ax.DataAspectRatio = [1 1 0.5];
XLabelPosition = ax.XLabel.Position;
YLabelPosition = ax.YLabel.Position;
view(-135,45)
ax.XLabel.Position=[2.4795 0.4269 -0.4247];
ax.YLabel.Position=[0.5247 2.2102 -0.5298];
set(ax,'FontName',FontName,'FontSize',FontSizeAx)
figMAC3000.Units='normalized';
figMAC3000.Position(3:4) = [0.32, 0.35];%[0.2 0.2];
ax.Units = 'Centimeters';
ax.Position(3:4) = [10,8];
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC3000,regexprep(filenameTikzMAC3000,'.tikz',''),'-dpng','-r400');

set(0, 'currentfigure', figMAC3000);
figure(figMAC3000.Number)
ax.XLabel.Position = XLabelPosition;
ax.YLabel.Position = YLabelPosition;
view(-30,70) % Ansicht von weiter oben
filenameTikzMAC3000hoch = [regexprep(filenameTikzMAC3000,'.tikz',''),'hoch.tikz'];
% export 2 pdf
% fig(k).Units = 'Centimeters';
% pos = get(fig(k),'Position');
% set(fig(k),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% print(fig(k),'GeomRotor3D','-dpdf','-painters') %sieht nicht so gut aus, mit '-opengl' ist es eine bitmap in einem pdf (auch schlecht)
print(figMAC3000,regexprep(filenameTikzMAC3000hoch,'.tikz',''),'-dpng','-r400');




%% Mode-comparison-figures speichern P=5000
numModes=length(fig5000);
x_scale_factor=1000;
y_scale_factor=1000;
z_scale_factor=1000;
for kMode=1:numModes
    kFig5000 = kMode;
    
filenameTikzModes{kMode} = ['tikz/P5000Mode',num2str(kMode),'.tikz'];

set(0, 'currentfigure', fig5000(kFig5000));
ax = gca;
axObjs = fig5000(kFig5000).Children;
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


%% Mode-comparison-figures speichern P=3000
numModes=length(fig3000);
x_scale_factor=1000;
y_scale_factor=1000;
z_scale_factor=1000;
for kMode=1:numModes
    kFig3000 = kMode;
    
filenameTikzModes{kMode} = ['tikz/P3000Mode',num2str(kMode),'.tikz'];

set(0, 'currentfigure', fig3000(kFig3000));
ax = gca;
axObjs = fig3000(kFig3000).Children;
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
if length(dataObjs)>4
dataObjs(5).Color = TUMblue; %Experiment
dataObjs(5).LineWidth = 1.5;
end

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



