FRFcurr = FRF{indexOutput,indexInput};
Cohcurr = Coh{indexOutput,indexInput};
inposition = FRFcurr.inputz; 
outposition = FRFcurr.outputz;
fExp = f;
HExp = FRFcurr.Data;
CohExp = Cohcurr;
TitleStr = FRFcurr.Title;
TitleFilename = TitleStr;
TitleFilename = regexprep(TitleFilename,'>','');
TitleFilename = regexprep(TitleFilename,' ','');
TitleFilename = regexprep(TitleFilename,'\(','');
TitleFilename = regexprep(TitleFilename,'\)','');
TitleFilename = regexprep(TitleFilename,'-','_');

TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);

LineWidth=1.5;
FontSize=12;
FontSizeLeg=10;
FontSizeTicks=9;
FontName='Helvetica';

disp([Pstr,' ',TitleStr])
% fExp=fExp;
% HExp = HExp; % Umrechnung in m/s^2/N
% CohExp = CohExp;

figure
subplot(2,1,1)
yyaxis left
title([Pstr,' ',TitleStr])
yyaxis left
semilogy(fExp,abs(HExp));
grid on
ylabel('FRF magnitude')
hold on
%legend('show')
yyaxis right
plot(fExp,CohExp)
ylabel('Coherence')
subplot(2,1,2)
plot(fExp,angle(HExp));
hold on
yticks(-2*pi:pi/2:2*pi)
% ylim([0 1]*pi)
grid on
ylabel('FRF angle')


%% Berechne FRF aus Simulation vgl. FRFfromMDK.m
% InputString = FRF.Input; % Positionen des Inputs
% OutputString = FRF.Output; % Positionen des Outputs
InputStringScript = {[num2str(inposition*1e3),'mm']}; % Positionen des Inputs
OutputStringScript = {[num2str(outposition*1e3),'mm']}; % Positionen des Outputs
disp(convertStringsToChars(strcat('Sim, Input ',InputStringScript)))
disp(convertStringsToChars(strcat('Sim, Output ',OutputStringScript)))
% disp(['Sim, Input ',InputString])
% disp(['Sim, Output ',OutputString])

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


fFEM=(0:0.2:250)';
% HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'d'));
HFEM = (mck2frf(fFEM,M,D,K,indof,outdof,'d')); % eigentlich richtig

% HFEM = (mck2frf(fFEM,M,D,K,indof,outdof,'d'))*10; % zum Ausprobieren, damit sieht alles cool aus

% Winkel zwischen -2pi und pi
angFEM=angle(HFEM);
angFEM(angFEM>0)=angFEM(angFEM>0)-2*pi;
angExp=angle(HExp);
angExp(angExp>0)=angExp(angExp>0)-2*pi;


i=1;
j=1;
figure
subplot(2,1,1)
yyaxis left
title(['MDK ',Pstr,' ',TitleStr])
DisplayName = ['Output',num2str(i)];
semilogy(fFEM(:),abs(HFEM(:,i,j)),'DisplayName',DisplayName);
grid on
ylabel('dyn. Nachgiebigkeit $|H|\big/\big(\mathrm{\frac{m}{N}}\big)$','Interpreter','Latex')
hold on
%legend('show')
subplot(2,1,2)
plot(fFEM(:),angFEM*180/pi);
hold on
% yticks(-2*pi:pi/2:2*pi)
yticks(-360:90:360)
% ylim([0 1]*pi)
grid on
ylabel('$\angle{H}$/Grad','Interpreter','Latex')


%% kombinierter plot
figBodeKombiniert=figure;
subplot(2,1,1)
title([Pstr,' Vergleich, ',TitleStr]);
semilogy(fFEM,abs(HFEM),'k-','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('dyn. Nachgiebigkeit $|H|\big/\big(\mathrm{\frac{m}{N}}\big)$','Interpreter','Latex')
hold on
grid on
semilogy(fExp,abs(HExp),':','DisplayName','Experiment','Color',TUMblue,'LineWidth',3);
leg=legend('show');
leg.Location='northwest';
xlim([0 1]*250)
subplot(2,1,2)
plot(fFEM,angFEM/2/pi*360,'k-','DisplayName','Winkel Simulation','LineWidth',1.5);
hold on
plot(fExp,angExp/pi*180,':','DisplayName','Winkel Experiment','Color',TUMblue,'LineWidth',3);
% yticks(-2*pi:pi/2:2*pi)
yticks(-360:90:360)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
legend('off')
ylabel('$\angle{H}$/$°$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*250)

%% kombinierter plot% doch aufgeteilt in Amp und Angle, da tikz mit subfigures nicht bzw. nicht gut funktioniert
figBodeKombiniertAmp=figure;
% title([Pstr,' Vergleich, ',FRF.Input,'->',FRF.Output]);
semilogy(fFEM,abs(HFEM),'k-','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('dyn. Nachgiebigkeit $|H|\big/\big(\mathrm{\frac{m}{N}}\big)$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
hold on
grid on
semilogy(fExp,abs(HExp),':','DisplayName','Experiment','Color',TUMblue,'LineWidth',LineWidth*2);
leg=legend('show');
leg.Location='northwest';
xlim([0 1]*250)

figBodeKombiniertAngle=figure;
plot(fFEM,angFEM/2/pi*360,'k-','DisplayName','Winkel Simulation','LineWidth',1.5);
hold on
plot(fExp,angExp/pi*180,'-','DisplayName','Winkel Experiment','Color',TUMblue,'LineWidth',LineWidth);
% yticks(-2*pi:pi/2:2*pi)
yticks(-360:90:360)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
legend('off')
ylabel('$\angle{H}$/$^\circ$','Interpreter','Latex')
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*250)

% Bode mit Kohaerenz
figBodeKoh=figure;
set(figBodeKoh,'defaultAxesColorOrder',[[0,0,0]; TUMorange]);
figBodeKoh.Units='Centimeters';
figBodeKoh.Position = [22.6473 10.3985 10 6];
figBodeKohSub1=subplot(2,1,1);
% title([Pstr,' Vergleich, ',TitleStr]);
yyaxis left
semilogy(fExp,abs(HExp),'DisplayName','Exp','LineWidth',LineWidth);%plot(fExp,abs(HExp),'DisplayName','Experiment');
% ax=gca;
% ax.Units = 'normalized';
% ax.Position = [0.1300 0.4100 0.7750 0.5150];
% set(ax,'FontName',FontName)%,'FontSize',FontSize)
grid on
ylabel('$|H|=\frac{X}{F}\big/\big(\mathrm{\frac{m}{N}}\big)$','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
hold on
semilogy(fFEM,abs(HFEM),'-','Color',TUMblue,'DisplayName','Sim','LineWidth',LineWidth);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
yyaxis right
plot(fExp,CohExp,'--','DisplayName','Koh','LineWidth',LineWidth)
ylabel('Koh\"arenz $\gamma_{yx}^2$','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
% leg=legend('show','Position',[0.7421 0.7548 0.1460 0.1715]);
leg=legend('show','Interpreter','Latex','FontSize',FontSizeLeg,'FontName',FontName,'Position',[0.7421 0.7548 0.1460 0.1715]);
% leg.Position=[0.7421 0.7548 0.1460 0.1715];
xlim([0 1]*250)
figBodeKohSub2=subplot(2,1,2);
plot(fExp,angExp/pi*180,'Color','black','LineWidth',LineWidth);
% ax=gca;
% ax.Units = 'normalized';
% ax.Position = [0.1300 0.1100 0.7750 0.2074];
% set(ax,'FontName',FontName)%,'FontSize',FontSize)
legend('off');
hold on
plot(fFEM,angFEM/2/pi*360,'Color',TUMblue,'LineWidth',LineWidth);
% yticks(-2*pi:pi/2:2*pi)
yticks(-360:180:360)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
ylabel('$\angle{H}$/Grad','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
xlabel('$f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
xlim([0 1]*250)
ylim([-360-10,0+10])
figBodeKoh.Units='Centimeters';
    figBodeKoh.Position=[54, 5, 14, 8];
    figBodeKohSub1.Position=[0.1300    0.4102    0.7750    0.5148];
    figBodeKohSub2.Position=[0.1300    0.1100    0.7750    0.2109];


% nur Amplitude
figBodeOnlyAmp=figure;
% set(figBodeOnlyAmp,'defaultAxesColorOrder',[[0,0,0]; TUMblue]);
% title(['Vergleich, ',HExpeader.Title]);%['Impact ',HExpeader.Title])
semilogy(fFEM,abs(HFEM),'black','DisplayName','Simulation','LineWidth',1.5);%plot(fFEM,abs(HFEM),'DisplayName','FEM');
ylabel('Akzeleranz $|H|/\frac{m}{N}$','Interpreter','Latex')
hold on
semilogy(fExp,abs(HExp),'DisplayName','Experiment','Color',TUMblue,'LineWidth',1.5);%plot(fExp,abs(HExp),'DisplayName','Experiment');
grid on
legend('show')
xlim([0 1]*400)
xlabel('$f$/Hz','Interpreter','Latex')
xlim([0 1]*300)


% Nyquist plot:
iExp = find(fExp<=250); % nur unterhalb von 250 Hz plotten
iFEM = find(fFEM<=250);
figNyquist=figure;
plot3(real(HExp(iExp)),imag(HExp(iExp)),fExp(iExp),'DisplayName','Experiment');
hold on
plot3(real(HFEM(iFEM)),imag(HFEM(iFEM)),fFEM(iFEM),'DisplayName','FEM');
title([Pstr,' Vergleich, ',TitleStr]);
xlabel('real')
ylabel('imag')
zlabel('f/Hz')
legend('show')
view(2)
% return
%% figure speichern
filenameTikzOnlyAmp = ['plots/BodeOnlyAmp',Pstr,TitleFilename,'.tikz'];

set(0, 'currentfigure', figBodeOnlyAmp);

% Exportiere zu tikz
cleanfigure()
matlab2tikz(filenameTikzOnlyAmp, 'height', '\fheight', 'width', '\fwidth' )

% mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
to_find = '\\addlegendentry{data';
to_replace = '\%\\addlegendentry{data';
find_and_replace(filenameTikzOnlyAmp, to_find, to_replace)

%% figure speichern
filenameTikzKombiniert = ['plots/BodeKombiniert',Pstr,TitleFilename,'.tikz'];

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

filenameTikzKombiniertAmp = ['plots/BodeKombiniert',Pstr,TitleFilename,'Amp.tikz'];
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

filenameTikzKombiniertAngle = ['plots/BodeKombiniert',Pstr,TitleFilename,'Angle.tikz'];
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

% matlab2tikz funktioniert nicht mit yyaxis 
filenameTikzKombiniertKoh = ['plots/BodeKombiniert',Pstr,TitleFilename,'Koh.tikz'];
set(0, 'currentfigure', figBodeKoh);
currFig=gcf
figure(currFig.Number)
% % Exportiere zu tikz
% cleanfigure()
% matlab2tikz(filenameTikzKombiniertKoh, 'height', '\fheight', 'width', '\fwidth' )
% % mit find_and_replace die Legendeneintraege in der tikz-Datei auskommentieren
% to_find = '\\addlegendentry{data';
% to_replace = '\%\\addlegendentry{data';
% find_and_replace(filenameTikzKombiniertKoh, to_find, to_replace)
% to_find = '\\addlegendentry{Winkel';
% to_replace = '\%\\addlegendentry{Winkel';
% find_and_replace(filenameTikzKombiniertKoh, to_find, to_replace)
% export 2 pdf
% figBodeKohSub1.Units = 'normalized';
% figBodeKohSub1.Position = [0.1300 0.4100 0.760 0.5150];
% set(figBodeKohSub1,'FontName',FontName)%,'FontSize',FontSize)
% if (indexInput==2) && (indexOutput==7)
%     leg.Position=[0.212974598684565,0.433242672844795,0.182539681120524,0.19383259399872];
% end

% figBodeKohSub2.Units = 'normalized';
% figBodeKohSub2.Position = [0.1300 0.1100 0.76 0.2074];
% set(figBodeKohSub2,'FontName',FontName)%),'FontSize',FontSize)
% figBodeKoh.Units='Centimeters';
leg.Position = [0.2318 0.4684 0.1460 0.1755];
export_fig(regexprep(filenameTikzKombiniertKoh,'.tikz',''),'-pdf','-transparent')
% pos = get(figBodeKoh,'Position');
% set(figBodeKoh,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)*1.2])
% % set(figBodeKoh,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[10, 8])
% print(figBodeKoh,regexprep(filenameTikzKombiniertKoh,'.tikz',''),'-dpdf','-painters')



% % export 2 pdf
% FontSize=12;
% FontName='Helvetica';
% 
% fig(k).Units='normalized';
% fig(k).Position(3:4) = [0.2 0.2];
% ax.Units = 'Centimeters';
% ax.Position(3:4) = [5,3];
% set(ax,'FontName',FontName,'FontSize',FontSize)