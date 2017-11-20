close all
load('Kraft');
load('Posi');
load('TUMFarben');

%figure('name','Polplan')
     
     
     %s=gcf;
     %set(s,'PaperPositionMode','auto');
     %print(s,'-djpeg',[pfad,name_str])
     
     subplot(2,2,1)
     hold on
     grid on
     title('Amplitude F_{L1}')
     plot(eta,c,'color',TUM.orange,'LineWidth',1.0);
     plot(eta,d,'color',TUM.gruen,'LineWidth',1.0);
     plot(eta,real(Gleichlauf_FL1(:,1))./5,'--k','LineWidth',1.0);
     plot(eta,imag(Gleichlauf_FL1(:,1))./5,'-.k','LineWidth',1.0);
     %plot(eta,real(Gleichlauf_FL1(:,1))./5,'+','color',TUM.blau,'LineWidth',1.2);
     %plot(eta,imag(Gleichlauf_FL1(:,1))./5,'o','color',TUM.blau,'LineWidth',1.2);
     xlabel('\eta');
     ylabel('[ - ]');
     legend('\eta^0','\eta^2','F_{L1}X','F_{L1}Y','Location',[0.48 0.48 1 1]);
     %axis([0 3 -15 15]);
     clear max
     clear min
     max=max(eta);
     min=min(eta);
     xlim([min-(max-min)*0.1, max+(max-min)*0.12]);
     hold off
     %s=gcf;
     %set(s,'PaperPositionMode','auto');
     %print(s,'-djpeg',[pfad,name_str])
     
     subplot(2,2,2)
     hold on
     grid on
     title('Vektoren F_{L1} F_{L2}')
     irgendwas = compass(real(F_L1_trenn(1)),imag(F_L1_trenn(1)),'-r');
     irgendwas.Color = TUM.orange;
     irgendwas.LineWidth = 1.0;
     irgendwas = compass(real(F_L2_trenn(1)),imag(F_L2_trenn(1)),'--r');
     irgendwas.Color = TUM.orange;
     irgendwas.LineWidth = 1.0;
     irgendwas = compass(real(F_L1_trenn(2)),imag(F_L1_trenn(2)),'-g');
     irgendwas.Color = TUM.gruen;
     irgendwas.LineWidth = 1.0;
     irgendwas = compass(real(F_L2_trenn(2)),imag(F_L2_trenn(2)),'--g');
     irgendwas.Color = TUM.gruen;
     irgendwas.LineWidth = 1.0;
     xlabel('x Wert Kraft  [ N ]');
     ylabel('y Wert Kraft  [ N ]');
     legend('F_{L1}(\eta^0)','F_{L2}(\eta^0)','F_{L1}(\eta^2)','F_{L2}(\eta^2)','Location',[0.3 0.42  1 1]);
     axis([-15,15,-15,15]);
     %axis([-0.6,0.6,-0.6,0.6]);
     
     
     subplot(2,2,3)
     hold on
     grid on
     title('Amplitude r')
     plot(eta,g,'Color',TUM.orange,'LineWidth',1.0);
     plot(eta,f,'Color',TUM.gruen,'LineWidth',1.0);
     plot(eta,real(r).*1000,'--k','LineWidth',1.0);
     plot(eta,imag(r).*1000,'-.k','LineWidth',1.0);
     legend('\eta^0','\eta^2','r_X','r_Y','Location',[0.48 0.4 1 1]);
     xlabel('\eta');
     ylabel('[ - ]');
     clear max
     clear min
     max=max(eta);
     min=min(eta);
     xlim([min-(max-min)*0.1, max+(max-min)*0.12]);
     hold off
      %s=gcf;
     %set(s,'PaperPositionMode','auto');
     %print(s,'-djpeg',[pfad,name_str])
     
     subplot(2,2,4)
     grid on
     hold on
     title('Vektoren r')
     irgendwas = compass(real(x(2)),imag(x(2)),'-r');
     irgendwas.Color = TUM.orange;
     irgendwas.LineWidth = 1.0;
     irgendwas = compass(real(x(1)),imag(x(1)),'-g');
     irgendwas.Color = TUM.gruen;
     irgendwas.LineWidth = 1.0;
     tem=legend('r_M(\eta^0)','r_M(\eta^2)','Location',[0.3 0.45 1 1]);
     xlabel('x Position  [ m ]');
     ylabel('y Position  [ m ]');
     axis([-15e-4,15e-4,-15e-4,15e-4]);
     %axis([-5e-5,5e-5,-5e-5,5e-5]);
     hold off
     %s=gcf;
     %set(s,'PaperPositionMode','auto');
     
    
     
     
    fig = gcf;
%fig.PaperPositionMode = 'auto';
fig.Units = 'centimeters';
fig.Position = [1 1 17 14];
%ax=gca;
%fig.Units = 'normalized';
%fig.Position = [0 0 0.9 0.9];

%Position: [488 342 560 420]
 %      Units: 'pixels'
 

