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


fFEM=(0:0.2:300)';
% HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'d'));
HFEM = (mck2frf(fFEM,M,D,K,indof,outdof,'d'));

% Winkel zwischen -2pi und pi
angFEM=angle(HFEM);
angFEM(angFEM>0)=angFEM(angFEM>0)-2*pi;
angExp=angle(HExp);
angExp(angExp>0)=angExp(angExp>0)-2*pi;


% Bode mit Kohaerenz
figBodeAmpKoh=figure;
set(figBodeAmpKoh,'defaultAxesColorOrder',[[0,0,0]; [0,0,0]]);
% title([Pstr,' Vergleich, ',TitleStr]);
yyaxis left
semilogy(fExp,abs(HExp),'k','DisplayName','Betrag$ $','LineWidth',1.5);%plot(fExp,abs(HExp),'DisplayName','Experiment');
axBodeKohAmp = gca;
% ax=gca;
% ax.Units = 'normalized';
% ax.Position = [0.1300 0.4100 0.7750 0.5150];
% set(ax,'FontName',FontName)%,'FontSize',FontSize)
grid on
ylabel('$|H|=\frac{X}{F}\big/\big(\mathrm{\frac{m}{N}}\big)$','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
hold on
yyaxis right
plot(fExp,CohExp,'-','DisplayName','Koh\"arenz$ $','LineWidth',1.5,'Color',TUMorange)
ylabel('Koh\"arenz $\gamma_{yx}^2$','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
% leg=legend('show','Position',[0.7421 0.7548 0.1460 0.1715]);
leg=legend('show','Interpreter','Latex','FontSize',FontSizeLeg,'FontName',FontName);
% leg.Position=[0.7421 0.7548 0.1460 0.1715];
xlabel('$f$/Hz','Interpreter','Latex','FontSize',FontSize,'FontName',FontName)
xlim([0 1]*300)
    


%% figure speichern
% matlab2tikz funktioniert nicht mit yyaxis 
filenameTikzKohAmp = ['plots/FRFExperiment',Pstr,TitleFilename,'Koh.tikz'];
set(0, 'currentfigure', figBodeAmpKoh);
currFig=gcf
figure(currFig.Number)
% export 2 pdf
% axBodeKohAmp.Units = 'normalized';
% axBodeKohAmp.Position = [0.1300 0.4100 0.7750 0.5150];
set(axBodeKohAmp,'FontName',FontName)%,'FontSize',FontSize)


figBodeAmpKoh.Units='Centimeters';
figBodeAmpKoh.Position=[54, 5, 14, 5];
export_fig(regexprep(filenameTikzKohAmp,'.tikz',''),'-pdf','-transparent')
% pos = get(figBodeAmpKoh,'Position');
% set(figBodeAmpKoh,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% % set(figBodeAmpKoh,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[10, 8])
% print(figBodeAmpKoh,regexprep(filenameTikzKohAmp,'.tikz',''),'-dpdf','-painters')