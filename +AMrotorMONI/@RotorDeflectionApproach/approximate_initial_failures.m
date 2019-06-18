function [InitialUnwuchtsMatrix,InitialSchlagMatrix,XInitial,InitialAchsversatzMatrix] = approximate_initial_failures(obj,dataset)
Debugging=obj.Debugging;

% Rotorparameter
f1 = obj.cnfg.Eigenfrequenz; %Eigenfrequenz
m1 = obj.cnfg.ModaleMasse1EO; %Rotormasse des 1. Modes % amplitude erster mode ,modale masse
m = obj.cnfg.MasseRotorGesamt; %Rotormasse gesamt
L = obj.cnfg.Lagerabstand; %Lagerabstand
zUnwucht = obj.cnfg.zPosUnwucht; %%%%% eingang in funtion nicht bestimmmbar durch code, nutzer legt unwuchtsposition durch schätzungen fest
zSensor = obj.cnfg.zPosSensor;
zLinkesLager = obj.cnfg.zLinkesLager;
uESF1=obj.ESF1.uESF1;
zESF1=obj.ESF1.zESF1;


Schluessel=keys(dataset);

for i1=1:(size(keys(dataset),2))
    
        temp=dataset(Schluessel{i1});
        Zeit=temp('time');
        Tacho=temp('n');
        phi=temp('Phi');
        xPos=temp('s_x (Positionssensor Scheibe)');
        yPos=temp('s_y (Positionssensor Scheibe)');
    
        [DrehzahlMess(i1), Gleichlauf_Auslenkung(i1), Gegenlauf_Auslenkung(i1), StatischeAuslenkung(i1),fourier(i1)] = analyse_deflection_fourier_coeff(obj,Zeit,xPos,yPos,Tacho,phi);
      
end


%% Berechnung des aktuellen Wellenzustands
% Aufstellen und Loesen des LGS
r = zeros(length(DrehzahlMess),1);
f = r; %Verstärkungsfkt. Unwucht
g = r; %Verstärkungsfkt. Schlag

uMess = interp1(zESF1,uESF1,zSensor,'spline');
uUnwucht = interp1(zESF1,uESF1,zUnwucht,'spline');
  eta = DrehzahlMess.*2*pi/60/f1;
    f = eta.^2./(1-eta.^2);
    g = 1./(1-eta.^2);
    r = Gleichlauf_Auslenkung.';

A = [f.',g.'];
x = A\r;
% Verschiebung entlang der Deformationskurve
x(1)= x(1)*m1/m/uMess/uUnwucht;

%% Debugging
% ++++++Debuggging++++++++
 if Debugging
     
%      groesse=length(fourier);
%      name_str = 'Fourier Trafo Position Auslenkung x';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).x;
%      Zeit=fourier(k).Zeit;
%      xPos=fourier(k).xPos;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,xPos,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Positionsmessung X \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
%      
%      name_str = 'Fourier Trafo Position Auslenkung y';
%      figure('Name', name_str);
%      for k=1:groesse
%      hold on;
%      subplot(4,3,k);
%      hold on;
%      tem=fourier(k).y;
%      Zeit=fourier(k).Zeit;
%      yPos=fourier(k).yPos;
%      omega=fourier(k).omega;
%      fft=tem.a0 + tem.a1*cos(Zeit*tem.w)+tem.b1*sin(Zeit*tem.w);
%      plot(Zeit,yPos,'b');
%      plot(Zeit,fft,'r--');
%      legend(['Positionsmessung Y \Omega: ',num2str(omega)],['Fouriertrafo \omega: ',num2str(tem.w)]);
%      hold off
%      end
     
     
     
     
%      name_str = 'Positionsvektoren_nach_division_mit_eta'; 
%      figure('Name', name_str);
%      hold on
%      grid on
%      irgendwas = compass(real(x(2)),imag(x(2)),'r');
%      irgendwas.Color = TUM.orange;
%      irgendwas = compass(real(x(1)),imag(x(1)),'g');
%      irgendwas.Color = TUM.gruen;
%      legend('Auslenkung Position \eta^0','Auslenkung Position \eta^2');
%      xlabel('x Position');
%      ylabel('y Position');
%      axis([-5e-4,5e-4,-5e-4,5e-4]);
%       s=gcf;
%      set(s,'PaperPositionMode','auto');
%      %print(s,'-djpeg',[pfad,name_str])
%      
%      name_str = 'Amplitudenplot_Positionsmessung'; 
%      figure('Name', name_str);
%      hold on
%      grid on
%      plot(eta,g,'Color',TUM.orange);
%      plot(eta,f,'Color',TUM.gruen);
%      plot(eta,real(r).*1000,'--k');
%      plot(eta,imag(r).*1000,'-.k');
%      legend('\eta^0','\eta^2','Position Amplitude X * 1000','Position Amplitude Y * 1000')
%      xlabel('\eta');
%      hold off
%       s=gcf;
%      set(s,'PaperPositionMode','auto');
%      %print(s,'-djpeg',[pfad,name_str])
%     save Posi r eta x g f
 end
 % ++++++Ende Debugging++++  

%% %% Aktuell gemessene Unwucht
% Phase Unwucht
phiUnwucht = atan2(imag(x(1)),real(x(1)));

BetragUnwucht = m1*abs(x(1));

InitialUnwuchtsMatrix = [zUnwucht BetragUnwucht phiUnwucht ];

%% Achsversatz

AVvec = mean(StatischeAuslenkung);
AV = abs(AVvec);
phiAV = atan2(imag(AVvec),real(AVvec));

InitialAchsversatzMatrix = [zSensor AV phiAV];

%% Aktuell gemessener quasi Schlag
% Phase Schalg
phiSchlag = atan2(imag(x(2)),real(x(2)));

% Radius Schlag

r0 = abs(x(2));
 
if (zSensor-zLinkesLager) > L/2
    R = abs(0.5*r0-(L-(zSensor-zLinkesLager))/r0*(L/2-(L-(zSensor-zLinkesLager))/2));
else
    R = abs(0.5*r0-(zSensor-zLinkesLager)/r0*(L/2-(zSensor-zLinkesLager)/2));
end
% XKreis=[0,zSensor,L];
% YKreis=[0,r0,0];
% [~, ~, R] = circfit(XKreis,YKreis);

InitialSchlagMatrix = [ R phiSchlag ];

% Übergabe für endberechnung

XInitial=[zUnwucht x(1);zSensor x(2)];

end