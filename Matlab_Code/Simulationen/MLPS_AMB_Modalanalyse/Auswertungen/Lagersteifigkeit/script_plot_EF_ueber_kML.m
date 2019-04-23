% script_animate_modes_over_stiffness
clear,close all
% load('EF_ueber_kML.mat')
load('animationsplot.mat')
TUMcolors
TUMblue=TUMcolor(1,:);
TUMorange=TUMcolor(2,:);
TUMgreen=TUMcolor(3,:);
LineWidth = 1;%1.5;
LineStyle = '-';

for i=1:length(kMLvec)
    ModenNummern = 1:length(EF{i});
    clear boolBiegung
    for n = 1:length(ModenNummern)
        boolBiegung(n) = norm(EVmain{i}(:,n))>1e-3;
%         EVmain{i}(:,n)=EVmain{i}(:,indexBiegung); % nur Moden mit Biegung
%         EF{i}=EF{i}(indexBiegung);
    end
    EVmain{i} = EVmain{i}(:,boolBiegung);
    EF{i}=EF{i}(boolBiegung);
end

% plot der EF der ersten Biegemoden über k:
% ModenNummern = 1:floor(0.8*length(EF{1}));%;[1,5,8];
ModenNummern = 1:2:12;
for n = 1:length(ModenNummern)
    ModenNummer = ModenNummern(n);
    for i=1:length(EF)
        Mode{n}.EFHz(i) = imag(EF{i}(ModenNummer))/2/pi;
    end
end
fig =figure;
for n = 1:length(ModenNummern)
    semilogx((kMLvec),Mode{n}.EFHz,'k','LineWidth',LineWidth,'LineStyle',LineStyle);
    hold on
end
grid on
title('Biegemoden')
xlabel('$k_{ML}$ [N/m]','Interpreter','Latex')
ylabel('$f$ [Hz]','Interpreter','Latex')
% print('EF_ueber_kML_log','-dpng','-r400');
ylimits=ylim;
plot([1 1]*3.5e4,ylimits,'Color',grau,'LineWidth',LineWidth,'LineStyle',LineStyle)
plot([1 1]*1.1e5,ylimits,'Color',grau,'LineWidth',LineWidth,'LineStyle',LineStyle)


figure
for n = 1:length(ModenNummern)
    plot((kMLvec),Mode{n}.EFHz)
    hold on
end
grid on
title('Biegemoden')
xlabel('k_{ML} [N/m]')
ylabel('EF [Hz]')


%save as pdf
FontSize=12;
FontName='Helvetica';
set(0, 'currentfigure', fig);
ylim([0 250])
figure(fig.Number)
title('')
xlim([1e3 1e7])
ax = gca;
set(ax,'FontName',FontName,'FontSize',FontSize)
fig.Units = 'Centimeters';
fig.Position(3:4) = [14,10];
pos = get(fig,'Position');
set(fig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(fig,['pdf/','EF_ueber_kML_log'],'-dpdf','-painters' )
% export_fig pdf/EF_ueber_kML_log -svg -transparent