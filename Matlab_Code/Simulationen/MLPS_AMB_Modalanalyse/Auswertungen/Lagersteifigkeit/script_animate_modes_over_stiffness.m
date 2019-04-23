% script_animate_modes_over_stiffness
clear,close all
load('animationsplot.mat')




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

figure
grid on
% hold on
xlimits = [0 1]*0.702;
xlim(xlimits);
% ylimits=[-1 1]*max(max(cell2mat(EVmain)));
ylimits=[-1 1]*0.03;
ylim(ylimits);
%animation:
for i=1:length(kMLvec)
    plot(xlimits,0*ylimits,'k','DisplayName','Nulllinie')
    hold on
    plot([1 1]*113e-3,ylimits,'k','DisplayName','MLleft')
    plot([1 1]*623e-3,ylimits,'k','DisplayName','MLright')
    plot(x{i},EVmain{i}(:,1),'DisplayName',sprintf('%1.2f Hz',imag(EF{i}(1))/2/pi))
%     plot(x{i},EVmain{i}(:,2),'DisplayName',sprintf('%1.2f Hz',imag(EF{i}(2))/2/pi))
    plot(x{i},EVmain{i}(:,5),'DisplayName',sprintf('%1.2f Hz',imag(EF{i}(5))/2/pi))
    plot(x{i},EVmain{i}(:,8),'DisplayName',sprintf('%1.2f Hz',imag(EF{i}(8))/2/pi))
    legend('show')
    hold off
    xlim(xlimits);
    ylim(ylimits);
    pause(0.02)
end

% % plot der EF der ersten Biegemoden über k:
% ModenNummern = 1:floor(0.8*length(EF{1}));%;[1,5,8];
% for n = 1:length(ModenNummern)
%     ModenNummer = ModenNummern(n);
%     for i=1:length(EF)
%         Mode{n}.EFHz(i) = imag(EF{i}(ModenNummer))/2/pi;
%     end
% end
% figure
% for n = 1:length(ModenNummern)
%     semilogx((kMLvec),Mode{n}.EFHz)
%     hold on
% end
% grid on
% title('Biegemoden')
% xlabel('k_{ML} [N/m]')
% ylabel('EF [Hz]')
% % print('EF_ueber_kML_log','-dpng','-r400');
% 
% 
% figure
% for n = 1:length(ModenNummern)
%     plot((kMLvec),Mode{n}.EFHz)
%     hold on
% end
% grid on
% title('Biegemoden')
% xlabel('k_{ML} [N/m]')
% ylabel('EF [Hz]')
% print('EF_ueber_kML','-dpng','-r400');

% figure
% for n = 1:length(ModenNummern)
% normEVmain=[];
% ivec=[];
% for i = 1:length(EVmain)
%     ivec = [ivec, i];
%     normEVmain = [normEVmain, norm(EVmain{i}(:,n))];
% end
% iVec{n} = ivec;
% NormEVmain{n} = normEVmain;
% plot(ivec,normEVmain)
% hold on
% end