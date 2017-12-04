%%% Modellierung  der Rotordynamik eines Lavalrotors
% von Robert Höfer 29.08.2017
clear all
close all
Drehzahlebereiche=[100 100 500;600 100 1000;1100 100 1500;100 200 1500];
save Drehzahlebereiche
RotorFehler = [1+1i 0 0 1+1i;0 1-1i 0 1-1i; 0 0 -1-1i -1-1i; -1+1i -1+1i -1+1i -1+1i]*1e-3;
save RotorFehler
Zweifach_Zaehler=[1 2 3 4, 1 2 3 4, 1 2 3 4, 1 2 3 4;1 1 1 1, 2 2 2 2, 3 3 3 3, 4 4 4 4];
save Zweifach_Zaehler
for GlobalerZeahler=1:16
    load Zweifach_Zaehler.mat
    load Drehzahlebereiche.mat
    load RotorFehler.mat
    Drehzahl=Zweifach_Zaehler(1,GlobalerZeahler);
    Rotorerror=Zweifach_Zaehler(2,GlobalerZeahler);


%Unwuchte
epsilon=RotorFehler(1,Rotorerror);%kgm
%schlag
a=RotorFehler(2,Rotorerror);
%Kupplungsversatz
bKV=RotorFehler(3,Rotorerror);
%Achsversatz
bAV=RotorFehler(4,Rotorerror);
     

jolo=num2str(Drehzahl);
hoho=num2str(Rotorerror);
cnfgLavalSim_3D.pfad=(['H:\BA\Robert_Hoefer_Paket\PowerPoint\',hoho,'\',jolo,'\']);



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
% %Unwuchte
% epsilon=1e-3+1i*1e-3; %kgm
% %schlag
% a=Fehler;
% %Kupplungsversatz
% bKV=0;%-0.0005+0.0001i;  % m
% %Achsversatz
% bAV=-0.0001+0.0001i;


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

for n=(Drehzahlebereiche(Drehzahl,1)):(Drehzahlebereiche(Drehzahl,2)):(Drehzahlebereiche(Drehzahl,3))
    Omega=n/60*2*pi;
    % Auslenkung an der Stelle der Scheibe
    r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
    r_X = real(r_M);
    r_Y = imag(r_M);
    % Verschiebung sensor entlang der Biegekurve
    r_verschoben_M = ( k_M*a + k_K*bKV + (Masse*epsilon*Omega^2)*double(wNorm(zPos_Sensor-zLinkesLager)) )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
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
    subplot(4,2,1);
    plot(t,r_X_Verschoben);
    title('r_X_Verschoben');
    xlabel('t[s]');
    hold on;
    subplot(4,2,2);
    plot(t,r_Y);
    title('r_Y');
    xlabel('t[s]');
    hold on;
    subplot(4,2,3);
    plot(t,F_X_L1);
    title('F_X_L1');
    xlabel('t[s]');
    hold on;
    subplot(4,2,4); 
    plot(t,F_Y_L1);
    title('F_Y_L1');
    xlabel('t[s]');
    hold on;
    subplot(4,2,5);
    plot(t,F_X_L2);
    title('F_X_L2');
    xlabel('t[s]');
    hold on;
    subplot(4,2,6); 
    plot(t,F_Y_L2);
    title('F_Y_L2');
    xlabel('t[s]');
    hold on;
    subplot(4,2,8);
    O=n*ones(1,size(t,2));
    plot(t,O);
    title('Drehzahlen [1/Min^1]');
    xlabel('t[s]');
    hold on;
    
    % amplituden
    k=k+1;
    rXM(k)=max(abs(r_X));
    rYM(k)=max(abs(r_Y));
    FXM(k)=max(abs(F_X_L1));
    FYM(k)=max(abs(F_Y_L1));
    FXM(k)=max(abs(F_X_L2));
    FYM(k)=max(abs(F_Y_L2));
    OmegaNeu(k)=Omega;
    

    
    
%% Abspeichern in für Monitoring Verarbeitbares Format
    
    dataset_monitoring(n)=containers.Map;
    tmp = dataset_monitoring(n);
tmp('time') = t;
tmp('s_x (Positionssensor Scheibe)') = r_X_Verschoben;
tmp('s_y (Positionssensor Scheibe)') = r_Y_Verschoben;
tmp('n') = O;
tmp('Phi') = Omega*t;
%tmp('s_xymisch (Positionssensor Scheibe)') = data(6,:);
tmp('F_x (Kraftsensor links)') = F_X_L1;
tmp('F_y (Kraftsensor links)') = F_Y_L1;
tmp('F_x (Kraftsensor rechts)') = F_X_L2;
tmp('F_y (Kraftsensor rechts)') = F_Y_L2;
    
    
    
end

%% Plot Amplitudenkurve

hold off;
subplot(4,2,7);
hold on;
plot(OmegaNeu, rXM,'xr');
plot(OmegaNeu, rYM,'b');
%set(gca,'YLim',[(-0.1)*max(rXM),(0.5)*max(rXM)]);
set(gca,'xLim',[OmegaNeu(1),OmegaNeu(end)]);
% plot(OmegaNeu, FXM);
% plot(OmegaNeu, FYM);
title('Amplituden');
xlabel('\Omega');
legend('|r_X| Max','|r_Y| Max')%,'|F_X| Max','|F_Y| max');
hold off;




%% Plot Biegekurve
% Plot Biegekurve
figure
y=0:0.001:Lges;
hold on
plot(zPos_ScheibeLinks,wNorm(L1),'xr');
temp=zPos_Sensor-zLinkesLager;
plot(zPos_Sensor,wNorm(temp),'+b');
plot([zPos_ScheibeLinks zPos_ScheibeLinks],[0 wNorm(L1)],'r');
plot([zPos_Sensor zPos_Sensor],[0 wNorm(temp)],'b--');
%plot(y,wNorm(y),'g-.');
plot(zESF1,uESF1,'g-.');
title('Normierte Biegekurve bei Angriff einer Einheitskraft an der Scheibe');
xlabel('z in [m]');
ylabel('wNorm(z)');
legend('Scheibe Position','Sensor Position');
hold off




%% Exportoptionen
cnfgLavalSim_3D.Lagerabstand = Lges;               %Abstand zwischen den beiden Auflagern in Meter
cnfgLavalSim_3D.Steifigkeit= k_M+k_K;%210000e+6*pi*0.008^4/64;
cnfgLavalSim_3D.Eigenfrequenz =  omega;         %Eigenfrequenz des Rotors in rad/sec.
cnfgLavalSim_3D.ModaleMasse1EO = Masse;   % kg bei Laval gleich mit Gesammtmasse
cnfgLavalSim_3D.MasseRotorGesamt = Masse;  % scheibe 6.6268 kg
cnfgLavalSim_3D.zPosUnwucht = zPos_ScheibeLinks;
cnfgLavalSim_3D.zPosSensor = zPos_Sensor;
cnfgLavalSim_3D.zLinkesLager = zLinkesLager;

save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\LavalParameter_3D.mat cnfgLavalSim_3D
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\DataSetSim_3D.mat dataset_monitoring
save H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\RotorConfiguration\ESF1_Simulation_Laval_3D.mat zESF1 uESF1

diary on
AktuelleFehlerinfo=[' Unwucht: ',num2str(RotorFehler(1,Rotorerror)),'   Schlag: ',num2str(RotorFehler(2,Rotorerror)),'   Kupplungsversatz: ',num2str(RotorFehler(3,Rotorerror)),'   Achsversatz: ',num2str(RotorFehler(4,Rotorerror))];
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
disp(AktuelleFehlerinfo);
disp('--------------------------------------------------------------------');
path(path,'H:\BA\Robert_Hoefer_Paket\')
AMrotorMONI.MainMonitoring
% meinPfad=cnfgLavalSim_3D.pfad;
% diary Comandofensterausgabe.txt;

end
diary off 