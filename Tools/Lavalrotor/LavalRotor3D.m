%%% Modellierung  der Rotordynamik eines Lavalrotors
% von Robert Höfer 29.08.2017
clear all
close all
clc
%% TUM Farben
load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\TUMFarben.mat')
co=[TUM.blau;TUM.gruen;TUM.schwarz08];
set(groot,'defaultAxesColorOrder',co,'DefaultAxesLineStyleOrder','-|--|-.');

%% Parameter
% Welle
E_modul=210000e+6;         % N/m²
d_welle=0.008;              % m
Laenge_welle=0.800;       % m
zLinkesLager=0.100;       % m
zRechtesLager=0.700;      % m
%Scheibe
zPos_ScheibeLinks=0.5075;  % m
zPos_Sensor=0.5075;
Breite_Scheibe=0.015;      % m
D_Scheibe=0.150;           % m
Dichte_Scheibe=7.446e+3;   % kg/m³
% Annäherung Scheibe als Punktmasse



%% Fehler
%Unwuchte
epsilon=1e-3 +1i*1e-3; %m
%Schlag
a= 1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= -1e-3 +1i*1e-3;  % m
%Achsversatz
bAV=-1e-3 -1i*1e-3;      % m


     



%% Berechungen

I_Traeheit=d_welle^4*pi/64; % m^4
EI=E_modul*I_Traeheit;  % N*m^2
Masse=D_Scheibe^2*pi/4*Breite_Scheibe*Dichte_Scheibe; %kg
Masse_Welle=d_welle^2*pi/4*(Laenge_welle-Breite_Scheibe)*Dichte_Scheibe;
Lges=Laenge_welle-Laenge_welle+zRechtesLager-zLinkesLager;
L2=Lges-zPos_ScheibeLinks+zLinkesLager;
L1=Lges-L2;
syms x


%% Durchbiegung
% Die Durchbiegung des Lavalrotors mit der Scheibe bei L1 durch eine 
% Einheitskraft F=1 welche die Unwucht repräsentiert,
% wird durch folgende Durchbiegungsfunktion abschnittsweise beschrieben

w(x)= (-1)/EI*(L2/Lges/6 * x^3 - heaviside(x-L1)/6* (x-L1)^3 + (L2^3/Lges/6 - L2*Lges/6)* x );
wstrich(x) = (-1)/EI* ( L2/Lges/2 * x^2 - heaviside(x-L1)/2* (x-L1)^2 + L2^3/Lges/6 - L2*Lges/6 );
% Federsteifigkeit berechnet anhand der Durchbiegung im Punkt der Scheibe

% bei  wirkenn einer  Kraft F=1
k_M=double(1/w(L1));
% Kupplunksstreifigkeit
k_K=1/10*k_M;

% Maximum der Biegekurve berechnen
if L2<L1
    xmax=sqrt(abs( ( 1/6*L2^3/Lges - 1/6*L2*Lges )/( 1/2*L2/Lges ) ));
elseif L2==L1
    xmax=L2;
else
    temp(1)=L1;
    temp(2)=L2;
    L1=L2;
    L2=temp(1);
    xmax=Lges-sqrt(abs( ( 1/6*L2^3/Lges - 1/6*L2*Lges )/( 1/2*L2/Lges ) ));
    L1=temp(1);
    L2=temp(2);
end




%% EigenSchwinfForm

wNorm(x)= w(x)/w(L1);
% ausgabe Diskreter werte
zESF1 = [];
uESF1 = [];
zESF1 = zeros(1,100);
uESF1 = zeros(100,1);
% Linker Rand
y=[];
y=linspace(0,zLinkesLager,21);
z=flip(y);
zESF1(1,1:20)=y(1:end-1);
uESF1(1:20,1)=double(-wstrich(0)/w(L1))*z(1:end-1);

% Mitte
y=[];
y=linspace(zLinkesLager,zRechtesLager,60);
z=linspace(0,Lges,60);
zESF1(1,21:80)=y;
uESF1(21:80,1)=double(wNorm(z));

%  rechter Rand
y=[];
y=linspace(zRechtesLager,Laenge_welle,21);
z=linspace(0,Laenge_welle-zRechtesLager,21);
zESF1(1,81:100)=y(2:end);
uESF1(81:100,1)=double(wstrich(Lges)/w(L1))*z(2:end);
y=[];


%% Dynamik Modellierung


%eigenfrequenz
omega=sqrt((k_M + k_K)/Masse);

% Auslenkung
t=(0:0.01:1);

k=0;


dataset_monitoring = containers.Map('KeyType','double','ValueType','any');

for n=500:100:700
    Omega=n/60*2*pi;
    % Auslenkung an der Stelle der Scheibe
    r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
    r_X = real(r_M);
    r_Y = imag(r_M);
    % Verschiebung sensor entlang der Biegekurve
    r_verschoben_M = double(wNorm(zPos_Sensor-zLinkesLager))*( k_M*a + k_K*bKV + (Masse*epsilon*Omega^2))/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
    r_X_Verschoben = real(r_verschoben_M);
    r_Y_Verschoben = imag(r_verschoben_M);
    
    % Kraft
    F_M = k_M *(r_M - a*exp(1i*Omega*t));

    F_X = real(F_M);
    
    F_X_L1 = L2/Lges*F_X;
    F_X_L2 = L1/Lges*F_X;
 
    
    F_Y = imag(F_M);
    
    F_Y_L1 = F_Y*L2/Lges;
    F_Y_L2 = F_Y*L1/Lges;
    
    
    
    % Ausgabe
    % Frequenzplots
    subplot(3,3,1);
    plot(t,r_X);
    title('r_X');
    xlabel('t in s');
    hold on;
    subplot(3,3,4);
    plot(t,r_Y);
    title('r_Y');
    xlabel('t in s');
    hold on;
    subplot(3,3,2);
    plot(t,F_X_L1);
    title('F_X L1');
    xlabel('t in s');
    hold on;
    subplot(3,3,5); 
    plot(t,F_Y_L1);
    title('F_Y L1');
    xlabel('t in s');
    hold on;
    subplot(3,3,3);
    plot(t,F_X_L2);
    title('F_X L2');
    xlabel('t in s');
    hold on;
    subplot(3,3,6); 
    plot(t,F_Y_L2);
    title('F_Y L2');
    xlabel('t in s');
    hold on;
    
    O=n*ones(1,size(t,2));
    
    %subplot(3,3,9);
    %plot(t,O);
    %title('Drehzahlen [1/Min^1]');
    %xlabel('t[s]');
    %hold on;
    
    % amplituden
    k=k+1;
    rXM(k)=max(abs(r_X));
    rYM(k)=max(abs(r_Y));
    rXMV(k)=max(abs(r_X_Verschoben));
    rYMV(k)=max(abs(r_Y_Verschoben));
    FXM1(k)=max(abs(F_X_L1));
    FYM1(k)=max(abs(F_Y_L1));
    FXM2(k)=max(abs(F_X_L2));
    FYM2(k)=max(abs(F_Y_L2));
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
tmp('F_x (Kraftsensor links)') = F_X_L1;
tmp('F_y (Kraftsensor links)') = F_Y_L1;
tmp('F_x (Kraftsensor rechts)') = F_X_L2;
tmp('F_y (Kraftsensor rechts)') = F_Y_L2;
    
    
    
end

%% Plot Amplitudenkurve
subplot(3,3,3)
%legend('n = 250','n = 500','n = 750','n = 1000');

hold off;
subplot(3,3,7);
hold on;
plot(OmegaNeu, rXM,'x','color',TUM.gruen);
plot(OmegaNeu, rYM,'color',TUM.blau);
%legend('|r_X| Max','|r_Y| Max');
set(gca,'xLim',[OmegaNeu(1),OmegaNeu(end)]);
title('|r_|');
xlabel('\Omega');
xlim([50,75]);
hold off
%set(gca,'YLim',[(-0.1)*max(rXM),(0.5)*max(rXM)]);
subplot(3,3,8);
hold on
plot(OmegaNeu, FXM1,'x','color',TUM.gruen);
plot(OmegaNeu, FYM1,'color',TUM.blau);
xlim([50,75]);
%set(gca,'xLim',[OmegaNeu(1),OmegaNeu(end)]);
title('|F_L_1|');
xlabel('\Omega');
%legend('|F_X 1| Max','|F_Y 1| max');
hold off;

subplot(3,3,9);
hold on
plot(OmegaNeu, FXM2,'x','color',TUM.gruen);
plot(OmegaNeu, FYM2,'color',TUM.blau);
xlim([50,75]);
%set(gca,'xLim',[OmegaNeu(1),OmegaNeu(end)]);
title('|F_L_2|');
xlabel('\Omega');
%legend('|F_X 2| Max','|F_Y 2| max');
hold off;

hold off

fig = gcf;
%fig.PaperPositionMode = 'auto';
fig.Units = 'centimeters';
fig.Position = [1 1 17 14];


% %% Plot Biegekurve
% % Plot Biegekurve
% figure
% y=0:0.001:Lges;
% hold on
% plot(zPos_ScheibeLinks,wNorm(L1),'x','color',TUM.gruen,'MarkerSize',10);
% temp=zPos_Sensor-zLinkesLager;
% plot(zPos_Sensor,wNorm(temp),'+','color',TUM.orange,'MarkerSize',10);
% plot(zLinkesLager,0,'xk','MarkerSize',10);
% plot(zRechtesLager,0,'xk','MarkerSize',10);
% 
% plot([zPos_ScheibeLinks zPos_ScheibeLinks],[0 wNorm(L1)],'color',TUM.gruen,'LineWidth',1);
% plot([zPos_Sensor zPos_Sensor],[0 wNorm(temp)],'--','color',TUM.orange,'LineWidth',1);
% %%%%plot(y,wNorm(y),'g-.');
% plot(zESF1,uESF1,'-.','color',TUM.blau,'LineWidth',1);
% title('Eigenschwingform erweiterter Lavalrotor');
% xlabel('zESF1');
% ylabel('uESF1');
% h=legend('Scheibe Position','Sensor Position','Lager 1','Lager 2');
% rect = [0.35, 0.15, .15, .15];
% set(h, 'Position', rect)
% 
% grid on;
% hold off





%% Exportoptionen
cnfgLavalSim_3D.Lagerabstand = Lges;               %Abstand zwischen den beiden Auflagern in Meter
cnfgLavalSim_3D.Steifigkeit= k_M;%210000e+6*pi*0.008^4/64;
cnfgLavalSim_3D.Eigenfrequenz =  omega;         %Eigenfrequenz des Rotors in rad/sec.
cnfgLavalSim_3D.ModaleMasse1EO = Masse;   % kg bei Laval gleich mit Gesammtmasse
cnfgLavalSim_3D.MasseRotorGesamt = Masse;  % scheibe 6.6268 kg
cnfgLavalSim_3D.zPosUnwucht = zPos_ScheibeLinks;
cnfgLavalSim_3D.zPosSensor = zPos_Sensor;
cnfgLavalSim_3D.zLinkesLager = zLinkesLager;
cnfgLavalSim_3D.pfad=(['H:\BA\Robert_Hoefer_Paket\PowerPoint\Tests\']);

save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\LavalParameter_3D.mat cnfgLavalSim_3D
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\DataSetSim_3D.mat dataset_monitoring
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\RotorConfiguration\ESF1_Simulation_Laval_3D.mat zESF1 uESF1
%path(path,'H:\BA\Robert_Hoefer_Paket\')

%AMrotorMONI.MainMonitoring

% % diary Comandofensterausgabe.txt;
% disp('Unwucht %f Schlag %f Kupplungsversatz %f Achsversatz', RotorFehler(:,LaufvarFehler))


%diary off 
r0=abs(a);
zSensor=zPos_Sensor;
L=Lges
if (zSensor-zLinkesLager) > L/2
    R = abs(0.5*r0-(L-(zSensor-zLinkesLager))/r0*(L/2-(L-(zSensor-zLinkesLager))/2));
else
    R = abs(0.5*r0-(zSensor-zLinkesLager)/r0*(L/2-(zSensor-zLinkesLager)/2));
end
