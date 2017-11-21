function [F_L1_rest,F_L2_rest,AnfangsUnwuchtsmatrix,AnfangsKupplungsversatz,Anfangsachsversatz]=approximate_initial_failures(obj,dataset)
% Berechnet gekoppelte Unwucht+Schlag und Kupplungsversatz
% Betrachtung nur von Gleichlauf!!

% Parameter Importieren 
Lagerabstand=obj.cnfg.Lagerabstand; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz =obj.cnfg.Eigenfrequenz;   %Eigenfrequenz des Rotors in rad/sec.
zLinkesLager = obj.cnfg.zLinkesLager;
Debugging=obj.Debugging;

%% Fourier transformation vom aktulellen Messwerte-Paket
Schluessel=keys(dataset);
for i1=1:size(keys(dataset),2)
    temp=dataset(Schluessel{i1});
    Zeit=temp('time');
    Tacho=temp('n');
    phi=temp('Phi');
    Kraft_L1_1=temp('F_x (Kraftsensor links)');
    Kraft_L1_2=temp('F_y (Kraftsensor links)');
    Kraft_L2_1=temp('F_x (Kraftsensor rechts)');
    Kraft_L2_2=temp('F_y (Kraftsensor rechts)');
    
    [Drehzahlmess(i1),OmegaExakt(i1),Gleichlauf_FL1(i1,:),Gegenlauf_FL1(i1,:), Gleichlauf_FL2(i1,:), Gegenlauf_FL2(i1,:),StatischeKraft_FL1(i1,:),StatischeKraft_FL2(i1,:),fourier(i1)] = analyse_force_fourier_coeff(obj,Zeit,Tacho,phi,Kraft_L1_1,Kraft_L1_2,Kraft_L2_1,Kraft_L2_2);
end


%% Aufstellen des Gleichungssystem
eta = 2*pi/60*Drehzahlmess./Eigenfrequenz;

c = 1./(1-eta.^2);
d = eta.^2./(1-eta.^2);

A = [c', d'];

 F_L1_trenn = A\Gleichlauf_FL1(:,1);      %Überbestimmtes Gleichungssystem lösen.
 F_L2_trenn = A\Gleichlauf_FL2(:,1);
 %Erste Zeile von F_L1_trenn entspricht Kupplungsversatz
 %Zweite Zeile entspricht den quadratisch skalierenden Anteilen
 
 % ++++++Debuggging++++++++
 if Debugging
     
%      groesse=length(fourier);
%      name_str = 'Fourier Trafo Kraft Lager 1 x';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).x1;
%      Zeit=fourier(k).Zeit;
%      L1X=fourier(k).L1X;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,L1X,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Kraftmessung L1x \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
%      
%      name_str = 'Fourier Trafo Kraft Lager 1 y';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).y1;
%      Zeit=fourier(k).Zeit;
%      L1Y=fourier(k).L1Y;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,L1Y,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Kraftmessung L1y \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
%      
%      name_str = 'Fourier Trafo Kraft Lager 2 x';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).x2;
%      Zeit=fourier(k).Zeit;
%      L2X=fourier(k).L2X;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,L2X,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Kraftmessung L2x \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
%      
%      name_str = 'Fourier_Trafo_Kraft_Lager_2_y';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).y2;
%      Zeit=fourier(k).Zeit;
%      L2Y=fourier(k).L2Y;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,L2Y,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Kraftmessung L2y \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
     
     
%      name_str = 'Kraftvektoren_nach_division_mit_eta'; 
%      figure('Name', name_str);
%      hold on
%      grid on
%      irgendwas = compass(real(F_L1_trenn(1)),imag(F_L1_trenn(1)),'r');
%      irgendwas.Color = TUM.orange;
%      irgendwas = compass(real(F_L1_trenn(2)),imag(F_L1_trenn(2)),'g');
%      irgendwas.Color = TUM.gruen;
%      irgendwas = compass(real(F_L2_trenn(1)),imag(F_L2_trenn(1)),'--r');
%      irgendwas.Color = TUM.orange;
%      irgendwas = compass(real(F_L2_trenn(2)),imag(F_L2_trenn(2)),'--g');
%      irgendwas.Color = TUM.gruen;
%      xlabel('x Wert Kraft');
%      ylabel('y Wert Kraft');
%      legend('Lager 1 \eta^0','Lager 1 \eta^2','Lager 2 \eta^0','Lager 2 \eta^2');
%      %axis([-16,16,-16,16]);
%      
%      s=gcf;
%      set(s,'PaperPositionMode','auto');
%      %print(s,'-djpeg',[pfad,name_str])
%      
%      name_str = 'Amplitudenplot_Kraftmessung'; 
%      figure('Name', name_str);
%      hold on
%      grid on
%      plot(eta,c,'color',TUM.orange);
%      plot(eta,d,'color',TUM.gruen);
%      plot(eta,real(Gleichlauf_FL1(:,1))/5,'--k');
%      plot(eta,imag(Gleichlauf_FL1(:,1))/5,'-.k');
%      xlabel('\eta')
%      legend('\eta^0','\eta^2','Lagerkraft F1 X * 1/5','Lagerkraft F1 Y * 1/5')
%      hold off
%      s=gcf;
%      set(s,'PaperPositionMode','auto');
%      %print(s,'-djpeg',[pfad,name_str])
     %save Kraft Gleichlauf_FL1 eta c d F_L1_trenn F_L2_trenn
 end
 % ++++++Ende Debugging++++
 
 
%% ------------------------------------------------------------------------
    %Annahme einer Quasi-Unwucht aus Schlag und echter Unwucht:
    
    Unwucht = abs(F_L1_trenn(2)+F_L2_trenn(2))/Eigenfrequenz^2;   % BA JM s 15 gl 25
    
    %Position der Unwucht über beide Momentenggw.:
    pos_rel = abs(F_L2_trenn(2))/(abs(F_L1_trenn(2))+abs(F_L2_trenn(2)));
    z1 = pos_rel*Lagerabstand + zLinkesLager;
   
    %Phase der Unwucht
    vektorUnwucht = F_L1_trenn(2)+F_L2_trenn(2);
    phi = atan2(imag(vektorUnwucht),real(vektorUnwucht));
    
    AnfangsUnwuchtsmatrix = [z1, Unwucht, phi];
%% ------------------------------------------------------------------------ 
    % Kupplungsversatz
    BKV = abs(F_L1_trenn(1)+F_L2_trenn(1));
    
    % Position des Kupplungsversatz über Momentenggw:
    pos_rel_BKV = abs(F_L2_trenn(1))/(abs(F_L1_trenn(1))+abs(F_L2_trenn(1)));
    z1_BKV = pos_rel_BKV*Lagerabstand + zLinkesLager;

    % Phase Kupplungsversatz
    vektorBKV = F_L1_trenn(1)+F_L2_trenn(1);
    phi_BKV = atan2(imag(vektorBKV),real(vektorBKV));
    
    AnfangsKupplungsversatz = [z1_BKV, BKV, phi_BKV];
    
    
%% ------------------------------------------------------------------------

% Achsversatz StatischeKraft_FL1(i1,:),StatischeKraft_FL2(i1,:)
AV_1= mean(StatischeKraft_FL1(:,1));
AV_2 = mean(StatischeKraft_FL2(:,1));
AV = abs(AV_1+AV_2);
pos_rel_AV = abs(AV_1)/(abs(AV_1)+abs(AV_2));
z1_AV = pos_rel_AV*Lagerabstand + zLinkesLager;

vektorAV = AV_1+AV_2;
phi_AV = atan2(imag(vektorAV),real(vektorAV));

Anfangsachsversatz = [z1_AV, AV, phi_AV];

%% ------------------------------------------------------------------------
    
    % Abspeichern der Kaftvektoren vom Initialsierungslauf für Differenz
    % Lauf
    F_L1_rest = F_L1_trenn;
    F_L2_rest = F_L2_trenn;

end
