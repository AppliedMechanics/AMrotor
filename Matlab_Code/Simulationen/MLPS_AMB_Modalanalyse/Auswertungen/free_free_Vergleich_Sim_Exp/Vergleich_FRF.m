clearvars -except SensorM, close all
% SensorM = 2; % 2,4 oder 6-> Ausgangssensor
% lade TUM-Farben
TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);

%% Vergleiche FRF aus Run 3 (W:\Rotordynamik\MLPS-Magnetlagerpruefstand\90_ModalAnalyse_2019_Impact_Kreutz)
% Anregung bei 46cm in X-
% Antwort an Sensor M4 in X (Pos: z=414mm)
% exportiere FRF aus LMS TestLab
switch SensorM
    case 2
        load('M2+X_A+X.mat')
    case 4
        load('M4+X_A2-X.mat')
    case 6
        load('M6+X_A+X.mat')
end

disp(FRF.Header.Title)
disp(Coh.Header.Title)
disp(' ')
fExp=FRF.Header.xStart:FRF.Header.xIncrement:(FRF.Header.NoValues-1)*FRF.Header.xIncrement;
HExp = (-real(FRF.Data)+1i*imag(FRF.Data))*9.80665; % Umrechnung in m/s^2/N
CohExp = Coh.Data;

figure
subplot(2,1,1)
yyaxis left
title(['Impact ',FRF.Header.Title])
yyaxis left
semilogy(fExp,abs(HExp));
grid on
ylabel('Akzeleranz $|H|$/$\frac{m/s^2}{N}$','Interpreter','Latex')
hold on

yyaxis right
plot(fExp,CohExp)
ylabel('Coherence')
subplot(2,1,2)
plot(fExp,angle(HExp)*180/pi);
hold on
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:180)
% ylim([0 1]*pi)
grid on
ylabel('$\angle{H}$/$°$','Interpreter','Latex')


%% Berechne FRF aus Simulation vgl. FRFfromMDK.m
load('Simulation_Matrices.mat')

% % Test geeigneter Knoten
inposition = [0,460]*1e-3; %Reihenfolge: A,A2
outposition = [51,76,151,190,307,414,568,594,675,692]*1e-3; % reihenfolge: M1,S1,S2,M2,M3,M4,M5,S3,S4,M6

switch SensorM
    case 2
        inposition = inposition(1);outposition = outposition(4); % fuer A->M2
    case 4
        inposition = 460e-3; outposition = 414e-3;
    case 6
        inposition = inposition(1);outposition = outposition(end); % fuer A->M6
end


InputString = {[num2str(inposition*1e3),'mm']}; % Positionen des Inputs
OutputString = {[num2str(outposition*1e3),'mm']}; % Positionen des Outputs
disp(convertStringsToChars(strcat('Sim, Input ',InputString)))
disp(convertStringsToChars(strcat('Sim, Output ',OutputString)))


indof = zeros(size(inposition));
outdof = zeros(size(outposition));
for k = 1:length(inposition)
    position = inposition(k);
    node_nr = r.rotor.find_node_nr(position);
    inposition_soll = position
    indof_real_position=r.rotor.mesh.nodes(node_nr).z
    delta_in(k) = inposition_soll-indof_real_position
    indof(k) = (node_nr-1)*6+1;
end
for k = 1:length(outposition)
    position = outposition(k);
    node_nr = r.rotor.find_node_nr(position);
    outposition_soll = position
    outdof_real_position=r.rotor.mesh.nodes(node_nr).z
    delta_out(k) = outposition_soll-outdof_real_position
    outdof(k) = (node_nr-1)*6+1;
end


fFEM=(0:0.2:400)';
HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'a')); % ACCELERATION mck2frf liefert konjugiert komplexen Wert der FRF

i=1;
j=1;
figure
subplot(2,1,1)
yyaxis left
title(['MDK ','Input ',InputString{j},', Output ',OutputString{i}])
DisplayName = ['Output',num2str(i)];
semilogy(fFEM(:),abs(HFEM(:,i,j)),'DisplayName',DisplayName);
grid on
ylabel('Akzeleranz $|H|/\frac{m/s^2}{N}$','Interpreter','Latex')
hold on
%legend('show')
subplot(2,1,2)
plot(fFEM(:),(angle(HFEM(:,i,j)))*180/pi);
hold on
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:180)
% ylim([0 1]*pi)
grid on
ylabel('$\angle{H}$/$°$','Interpreter','Latex')


%% kombinierter plot
figBodeKombiniert=figure;
subplot(2,1,1)
title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
semilogy(fFEM,abs(HFEM),'k-','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('Akzeleranz $|H|$/m/s^2/N','Interpreter','Latex')%ylabel('Akzeleranz $|H|/\frac{m/s^2}{N}$','Interpreter','Latex')
hold on
grid on
semilogy(fExp,abs(HExp),':','DisplayName','Experiment','Color',TUMblue,'LineWidth',3);
leg=legend('show');
leg.Location='northwest';
xlim([0 1]*250)
subplot(2,1,2)
plot(fFEM,angle(HFEM)/2/pi*360,'k-','DisplayName','Winkel Simulation','LineWidth',1.5);
hold on
plot(fExp,angle(HExp)/pi*180,':','DisplayName','Winkel Experiment','Color',TUMblue,'LineWidth',3);
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:180)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
legend('off')
ylabel('$\angle{H}$/$°$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*250)

%% kombinierter plot% doch aufgeteilt in Amp und Angle, da tikz mit subfigures nicht bzw. nicht gut funktioniert
figBodeKombiniertAmp=figure;
% title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
semilogy(fFEM,abs(HFEM),'k-','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('Akzeleranz $|H|$/m/s$^2$/N','Interpreter','Latex')%ylabel('Akzeleranz $|H|/\frac{m/s^2}{N}$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
hold on
grid on
semilogy(fExp,abs(HExp),':','DisplayName','Experiment','Color',TUMblue,'LineWidth',3);
leg=legend('show');
leg.Location='northwest';
xlim([0 1]*250)

figBodeKombiniertAngle=figure;
plot(fFEM,angle(HFEM)/2/pi*360,'k-','DisplayName','Winkel Simulation','LineWidth',1.5);
hold on
plot(fExp,angle(HExp)/pi*180,':','DisplayName','Winkel Experiment','Color',TUMblue,'LineWidth',3);
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:180)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
legend('off')
ylabel('$\angle{H}$/$^\circ$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*250)

% Bode mit Kohaerenz
figBodeKoh=figure;
set(figBodeKoh,'defaultAxesColorOrder',[[0,0,0]; TUMblue]);
subplot(2,1,1)
title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
yyaxis left
semilogy(fExp,abs(HExp),'DisplayName','Impact');%plot(fExp,abs(HExp),'DisplayName','Impact');
grid on
ylabel('Akzeleranz $|H|/\frac{m/s^2}{N}$','Interpreter','Latex')
hold on
semilogy(fFEM,abs(HFEM),'DisplayName','FEM');%plot(fFEM,abs(HFEM),'DisplayName','FEM');
yyaxis right
plot(fExp,CohExp)
ylabel('Kohärenz $\gamma_{xy}^2$','Interpreter','Latex')
legend('show')
xlim([0 1]*400)
subplot(2,1,2)
plot(fExp,wrapTo2Pi(angle(HExp))/pi*180);
hold on
plot(fFEM,wrapToPi(angle(HFEM))/2/pi*360);
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:360)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
ylabel('$\angle{H}$/$°$','Interpreter','Latex')
xlim([0 1]*400)

% nur Amplitude
figBodeOnlyAmp=figure;
% set(figBodeOnlyAmp,'defaultAxesColorOrder',[[0,0,0]; TUMblue]);
% title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
semilogy(fFEM,abs(HFEM),'black','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('Akzeleranz $|H|/\frac{m/s^2}{N}$','Interpreter','Latex')
hold on
semilogy(fExp,abs(HExp),'DisplayName','Experiment','Color',TUMblue,'LineWidth',1.5);%plot(fExp,abs(HExp),'DisplayName','Impact');
grid on
legend('show')
xlim([0 1]*400)
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*300)


% Nyquist plot:
iExp = find(fExp<=250); % nur unterhalb von 250 Hz plotten
iFEM = find(fFEM<=250);
figure
plot3(real(HExp(iExp)),imag(HExp(iExp)),fExp(iExp),'DisplayName','Impact');
hold on
plot3(real(HFEM(iFEM)),imag(HFEM(iFEM)),fFEM(iFEM),'DisplayName','FEM');
title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
xlabel('real')
ylabel('imag')
zlabel('f/Hz')
legend('show')
view(2)

%% figure speichern
filenameTikzOnlyAmp = ['tikz/BodeOnlyAmp',num2str(SensorM),'.tikz'];

set(0, 'currentfigure', figBodeOnlyAmp);

% Exportiere zu tikz
cleanfigure()
matlab2tikz(filenameTikzOnlyAmp, 'height', '\fheight', 'width', '\fwidth' )

% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzOnlyAmp, to_find, to_replace)

%% figure speichern
filenameTikzKombiniert = ['tikz/BodeKombiniert',num2str(SensorM),'.tikz'];
set(0, 'currentfigure', figBodeKombiniert);
% Exportiere zu tikz
cleanfigure()
matlab2tikz(filenameTikzKombiniert, 'height', '\fheight', 'width', '\fwidth' )
% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzKombiniert, to_find, to_replace)
to_find = '\\addlegendentry{Winkel';
to_replace = '\%\\addlegendentry{Winkel';
find_and_replace(filenameTikzKombiniert, to_find, to_replace)

filenameTikzKombiniertAmp = ['tikz/BodeKombiniert',num2str(SensorM),'Amp.tikz'];
set(0, 'currentfigure', figBodeKombiniertAmp);
% Exportiere zu tikz
cleanfigure()
matlab2tikz(filenameTikzKombiniertAmp, 'height', '\fheight', 'width', '\fwidth' )
% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzKombiniertAmp, to_find, to_replace)
to_find = '\\addlegendentry{Winkel';
to_replace = '\%\\addlegendentry{Winkel';
find_and_replace(filenameTikzKombiniertAmp, to_find, to_replace)

filenameTikzKombiniertAngle = ['tikz/BodeKombiniert',num2str(SensorM),'Angle.tikz'];
set(0, 'currentfigure', figBodeKombiniertAngle);
% Exportiere zu tikz
cleanfigure()
matlab2tikz(filenameTikzKombiniertAngle, 'height', '\fheight', 'width', '\fwidth' )
% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzKombiniertAngle, to_find, to_replace)
to_find = '\\addlegendentry{Winkel';
to_replace = '\%\\addlegendentry{Winkel';
find_and_replace(filenameTikzKombiniertAngle, to_find, to_replace)



% % export 2 pdf
% FontSize=12;
% FontName='Helvetica';
% 
% fig(k).Units='normalized';
% fig(k).Position(3:4) = [0.2 0.2];
% ax.Units = 'Centimeters';
% ax.Position(3:4) = [5,3];
% set(ax,'FontName',FontName,'FontSize',FontSize)