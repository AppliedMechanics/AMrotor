%%% Modellierung  der Rotordynamik eines Lavalrotors
% von Robert Höfer 29.08.2017
clear all
clc

%% Parameter
% Welle
E_modul=210000e+6;         % N/m²
d_welle=0.008;              % m
Laenge_welle=0.800;       % m
Lagerabstand=0.600;       % m   Mittig der Leange_welle
zLinkesLager =0.100;      % m
% Scheibe
zPos_ScheibeLinks = Laenge_welle/2; %Hier Mittig
Breite_Scheibe=0.015;      % m
D_Scheibe=0.150;           % m
Dichte_Scheibe=7.446e+3;   % kg/m³



%% Fehler

%Unwuchte
epsilon= 1e-3 +1i*1e-3; %m
%Schlag
a= 1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= -1e-3 +1i*1e-3;  % m
%Achsversatz
bAV=-1e-3 -1i*1e-3;      % m



%% Berechnungen Parameter

Lges = Lagerabstand;
I = pi/64*d_welle^4;
k_M = 48*E_modul*I/Lges^3;               % N/m
k_K=k_M/10;

Masse=D_Scheibe^2*pi/4*Breite_Scheibe*Dichte_Scheibe; %kg




%% Alibi ESF (konstante Gerade notwendig für berechungsverfahren)

zESF1=(0:0.005:Laenge_welle);
uESF1=ones(length(zESF1),1);




%% Dynamik Modellierung
% Auslenkung
t=(0:0.01:1);
omega=sqrt((k_M+k_K)/Masse);

k=0;
dataset_monitoring = containers.Map('KeyType','double','ValueType','any');
for n=200:200:1800
    Omega=n/60*2*pi;
    r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
    r_X = real(r_M);
    r_Y = imag(r_M);
    % Kraft
    F_M = k_M *(r_M - a*exp(1i*Omega*t));
    F_X = real(F_M);
    F_Y = imag(F_M);
    
 
    % Ausgabe
    subplot(3,2,1);
    plot(t,r_X);
    title('r_X');
    xlabel('t[s]');
    hold on;
    subplot(3,2,2);
    plot(t,r_Y);
    title('r_Y');
    xlabel('t[s]');
    hold on;
    subplot(3,2,3);
    plot(t,F_X);
    title('F_XGesammt');
    xlabel('t[s]');
    hold on;
    subplot(3,2,4); 
    plot(t,F_Y);
    title('F_YGesammt');
    xlabel('t[s]');
    hold on;
    subplot(3,2,6);
    O=Omega*ones(1,size(t,2));
    plot(t,O);
    title('Drehzahlen [1/min]');
    xlabel('t[s]');
    hold on;
    
    % amplituden
    k=k+1;
    rXM(k)=max(abs(r_X));
    rYM(k)=max(abs(r_Y));
    FXM(k)=max(abs(F_X));
    FYM(k)=max(abs(F_Y));
    OmegaNeu(k)=Omega;

   %% Abspeichern in für Monitoring Verarbeitbares Format
    
    dataset_monitoring(n)=containers.Map;
    tmp = dataset_monitoring(n);
tmp('time') = t;
tmp('s_x (Positionssensor Scheibe)') = r_X;
tmp('s_y (Positionssensor Scheibe)') = r_Y;
tmp('n') = O;
tmp('Phi') = Omega*t;
%tmp('s_xymisch (Positionssensor Scheibe)') = data(6,:);
tmp('F_x (Kraftsensor links)') = F_X/2;
tmp('F_y (Kraftsensor links)') = F_Y/2;
tmp('F_x (Kraftsensor rechts)') = F_X/2;
tmp('F_y (Kraftsensor rechts)') = F_Y/2;



end
hold off;



%% Plot der Amplitudenkurve

subplot(3,2,5);
hold on;
plot(OmegaNeu, rXM,'xr');
plot(OmegaNeu, rYM,'b');
%set(gca,'YLim',[(-0.1)*max(rXM),(0.5)*max(rXM)]);
set(gca,'xLim',[OmegaNeu(1),OmegaNeu(end)]);
% plot(OmegaNeu, FXM);
% plot(OmegaNeu, FYM);
title('Amplituden');
xlabel('\Omega');
legend('|r_X| Max','|r_Y| Max');%,'|F_X| Max','|F_Y| max');
hold off;


%% Exportoptionen
cnfgLavalSim_2D.Lagerabstand = Lges;               %Abstand zwischen den beiden Auflagern in Meter
cnfgLavalSim_2D.Steifigkeit= k_M;%210000e+6*pi*0.008^4/64;
cnfgLavalSim_2D.Eigenfrequenz =  omega;         %Eigenfrequenz des Rotors in rad/sec.
cnfgLavalSim_2D.ModaleMasse1EO = Masse;   % kg bei Laval gleich mit Gesammtmasse
cnfgLavalSim_2D.MasseRotorGesamt = Masse;  % scheibe 6.6268 kg
cnfgLavalSim_2D.zPosUnwucht = zPos_ScheibeLinks;
cnfgLavalSim_2D.zPosSensor = zPos_ScheibeLinks;
cnfgLavalSim_2D.zLinkesLager = zLinkesLager;

save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\LavalParameter_2D.mat cnfgLavalSim_2D
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\DataSetSim_2D.mat dataset_monitoring
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\RotorConfiguration\ESF1_Simulation_Laval_2D.mat zESF1 uESF1