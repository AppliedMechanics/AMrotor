%% *Modellierung Rotor mit FEM und modaler Reduktion*
%
% *Basierend auf: Rotormodell Markus Roßner, Christian Wagner, AM*
%
% Johannes Maierhofer
% Angewandte Mechanik TUM
% 05.07.2016
%
% Version 03
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *Datenstruktur*
%
% data(i,j,k) --> i Sensor, j Zeilen der Messwerte, k Drehzahl
%
% data(1)  = [s] Zeit
% data(2)  = [m] Wirbelstromsensor_z1 (Global Lager1:  x - Richtung)
% data(3)  = [m] Wirbelstromsensor_y1 (Global Lager1:  Y - Richtung)
% data(4)  = [m] Wirbelstromsensor_z2 (Global Lager2:  x - Richtung)
% data(5)  = [m] Wirbelstromsensor_y2 (Global Lager2:  Y - Richtung)
% data(6)  = [m] Lasersensor_z (Global Scheibe:  x - Richtung)
% data(7)  = [m] Lasersensor_y (Global Scheibe:  Y - Richtung)
% data(8)  = [A] Magnetlagerstrom_z1 (Global Lager1:  x - Richtung)
% data(9)  = [A] Magnetlagerstrom_y1 (Global Lager1:  y - Richtung)
% data(10)  = [A] Magnetlagerstrom_z2 (Global Lager1:  x - Richtung)
% data(11)  = [A] Magnetlagerstrom_y2 (Global Lager1:  y - Richtung)
% data(12)  = [U/min] Drezahl aus Inkrementalgeber
% data(13)  = [grad] Winkel aus Inkrementalgeber
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *Datenstruktur - Übertragungsfunktion*
%
% frf(1) = [s] Zeit
% frf(2) = [m] Anregung x1 (Global Lager1)
% frf(3) = [m] Anregung y1 (Global Lager1)
% frf(4) = [m] Anregung x2 (Global Lager2)
% frf(5) = [m] Anregung y2 (Global Lager2)
% frf(6) = [m] Antwort x1
% frf(7) = [m] Antwort y1
% frf(8) = [m] Antwort x2
% frf(9) = [m] Antwort y2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *Annahmen, Randbedingungen*
%
% Kosy: |x oy ->z am Swp
% Bernoulli Balkenelemente
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%% Clean up
clc
clear all
close all

addpath('FEMRotor');
addpath('../Postprocess');
addpath('../Matlab2Tikz');

%% Allgemeine Parameter
%common.g=9.81; %m/s^2 Gravitationskonstante

common.T = 1e-3; %s Schrittweite
common.Tend = 12; %s Simulationsdauer

Drehzahlen = [800:100:801]; %U/min

%% Magnetlager Kennwerte

% Reglerparameter
mag.Kp=8000;% A/m
%mag.Kp=6000;
mag.Ki=1500;  % A/m*s
mag.Kd=5;   % A*s/m
%mag.Kd=1.5;

% Strombegrenzung
mag.I_max = 5.0; 						%[A] maximaler Verstärkerstrom
mag.I_min = 0.0; 						%[A] minimaler Verstärkerstrom

%Vormagnetisierung
mag.Iv = 2.5;    						%[A] Vormagnetisierungsstrom

% % Materialparameter Magnetlager
% Aus Kennlinien Katrin Baumann: k = 3.63e-06 Nm^2/A^2
mag.kMag = (4*pi*1e-7)*(2.9e-4)*(2*104)^2*cos(22.5/180*pi)/4; %TU-DA, Geometrie des Magnetlagers
mag.s0 = 780e-6; % Ruheluftspalt
mag.k_i = +mag.kMag*4*mag.Iv/mag.s0^2; % N/A
mag.k_s = +mag.kMag*4*mag.Iv^2/mag.s0^3; % N/m %negativ nach TU-DA, positiv nach Insam

mag.k_i = 40; %[N/A] Messung JM

%% FEM-ANALYSE EINES ROTORS

%Wellengeometrie in ErzeugeKM eintragen

%Steifigkeits, Massenmatrix und Dämpfung erzeugen
[sys,par]=ErzeugeKM();
%

K=sys.K;
M=sys.M;
D=sys.D;

%Dämpfung, Diskret
%Eingabe [d11 d12 d21 d22][Position]
% DampCoeff = [100 0 0 100; 100 0 0 100];
% DampPos = [0 0.5];
% Dl = AssembleMatrixkoeffizientenCW(par,DampCoeff,DampPos);
% D = D+Dl;


%Modale Reduktion
par.Moden = 10; %Anzahl Eigenvektoren, Freiheitsgrade nach Modalanalyse

%Parameter für Lagermodell und Dichtungen
sys.p0=0;

% Definition Last-Vektoren
h.h = zeros(4*length(par.Knoten),1); %konstante statorfeste Last
h.h_ZPsin = h.h; %Zentripetal-Beschleunigungen, Rotorfest
h.h_ZPcos = h.h;
h.h_DBsin = h.h; %Drehbeschleunigungen
h.h_DBcos = h.h;
h.h_sin = h.h;
h.h_cos = h.h;
h.h_rotsin = h.h;
h.h_rotcos = h.h;

% % Unwuchtmassen

%Unwucht1 = [0.35,50e-6,45*pi/180]; %Parameter in Form [Position, m*e, psi], m klein gegenueber Rotormasse
%[h] = Ergaenze_Unwuchtmasse(h,par,Unwucht1);

Unwucht2 = [0.35,280e-6,0*pi/180]; %Parameter in Form [Position, m*e, psi], m klein gegenueber Rotormasse
[h] = Ergaenze_Unwuchtmasse(h,par,Unwucht2);

%% Anregungen #Stabilitätstest

time=0:common.T:common.Tend;

par.Anregung_Weg_inertial_1 = [zeros(size(time));zeros(size(time))];
par.Anregung_Weg_inertial_2 = [zeros(size(time));zeros(size(time))];

% Chirp
%par.Anregung_Weg_inertial_1 = 2.5e-5*[chirp(time,0,1,600);chirp(time,0,1,200)]; %[m]  x,y - Richtung
%par.Anregung_Weg_inertial_1 = 2.5e-5*[chirp(time,0,1,600);zeros(size(time))]; % [m]   x - Richtung


%================================================================================
%==========================================================================
% Eigenwerte/Vektoren
%==========================================================================

% M=M(1:30,1:30);
% K=K(1:30,1:30);
% 
% M(5,:)=[];M(24,:)=[];
% M(:,5)=[];M(:,24)=[];
% 
% K(5,:)=[];K(24,:)=[];
% K(:,5)=[];K(:,24)=[];
% 
% par.Moden=5;
% 

%%
[EV,EW] = eigs(K,M,par.Moden,'sm');
EW= diag(EW);

%%
% EV1=[EV(1:4,:);zeros(1,5);EV(5:23,:);zeros(1,5);EV(24:end,:)];
% EV=EV1(1:2:end,:);
%%
m.EV = EV;
m.ew = EW;
% Modaltransformation und Reduktion
m.Mr = EV'*M*EV;
m.Kr = EV'*K*EV;
m.Dr = EV'*D*EV;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% plot(EV(1:2:end/2,9));
% hold on;
% plot(EV(1:2:end/2,7));
% plot(EV(1:2:end/2,5));
% plot(EV(1:2:end/2,3));
% plot(EV(1:2:end/2,1));
% title='Eigenvektoren des FEM-Modell';
% legend(['1. Eigenform: ', num2str(sqrt(EW(9))/(2*pi)), 'Hz' ],['2. Eigenform: ', num2str(sqrt(EW(7))/(2*pi)), 'Hz' ],['3. Eigenform: ',num2str(sqrt(EW(5))/(2*pi)), 'Hz' ],['4. Eigenform: ',num2str(sqrt(EW(3))/(2*pi)), 'Hz' ],['5. Eigenform: ',num2str(sqrt(EW(1))/(2*pi)), 'Hz' ]);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath('../Matlab2Tikz');
% % help matlab2tikz
% 
% Datum = datestr(datetime('now'));
% Datum(ismember(Datum,' :')) = ['-'];
% [fpathstr,fname,fext] = fileparts(which(mfilename));
% 
% cleanfigure;
% matlab2tikz('tikzFileComment',['%%% Johannes Maierhofer -', Datum, ' %%%'],'height','\fheight','width','\fwidth','filename',['Eigenmoden_', fname, '__', Datum, '.tikz']);
% 
% hf = gcf;
% set(hf,'PaperOrientation','landscape');
% set(hf,'PaperUnits','normalized');
% set(hf,'PaperPosition', [0 0 1 1]);
% print(gcf, '-dpdf',['Eigenmoden_', fname, '__' ,Datum, '.pdf']); 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m.h =          EV'*h.h;
m.h_ZPsin =    EV'*h.h_ZPsin; %Zentripetal-Beschleunigungen, Rotorfest
m.h_ZPcos =    EV'*h.h_ZPcos;
m.h_DBsin =    EV'*h.h_DBsin; %Drehbeschleunigungen
m.h_DBcos =    EV'*h.h_DBcos;
m.h_sin =      EV'*h.h_sin;
m.h_cos =      EV'*h.h_cos;
m.h_rotsin =      EV'*h.h_rotsin;
m.h_rotcos =      EV'*h.h_rotcos;

vEF=sqrt(EW)./(2*pi);

%% Solve

%Zustand 0 für alle setzen:
Z0 = zeros(2*par.Moden+2+4,1).';

time=[0:common.T:common.Tend];

VZ= zeros(length(time),length(Z0),length(Drehzahlen)); % Ergebnisvektor vorbelegen

for i =1:length(Drehzahlen)

    %% Kompensationswerte

komp.EO=1;
komp.phase=(Unwucht2(3))/180*pi;
komp.amp=0.5*(Unwucht2(2)*(Drehzahlen(1,i)/60*2*pi)^2)/mag.k_i;
komp.amp=0;
%%
    
    Z0(2)=Drehzahlen(1,i)/60*2*pi; % Anfangswert der Drehzahl korrekt setzen.
    omi=   Drehzahlen(1,i);
    
    
    m.M = m.Mr;% + EV'*Md*EV;
    m.K = m.Kr;% + EV'*Kd*EV +  EV'*sys.KI*EV*omi;
    m.D = m.Dr;% + EV'*Dd*EV +  EV'*sys.G*EV*omi + EV'*sys.DI*EV;
    
    %==============================================================================
    options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6, 'OutputFcn','odeprint','OutputSel',[2]);
    [T,Z] = ode45(@sys_rotor_FEM_modal_JM_v021,time,Z0,options,sys,par,m,common,mag,komp,h);
    
    VZ(:,:,i)=Z;
    
    %% Rücktransformation
    
    mX= Z(:,3:2+par.Moden);
    X= m.EV*mX';
    
    %Position der Sensoren auswählen und passenden Knoten dazu finden.
    Position_1=0.1; %m
    [P_1] = SucheKnotenZuPositionCW(par,Position_1);%x beta y alpha
    Position_S=0.35; %m
    [P_S] = SucheKnotenZuPositionCW(par,Position_S);%x beta y alpha
    Position_2=0.60; %m
    [P_2] = SucheKnotenZuPositionCW(par,Position_2);%x beta y alpha
    
    s_1 = [X(P_1(1),:)',X(P_1(3),:)'];
    s_S = [X(P_S(1),:)',X(P_S(3),:)'];
    s_2 = [X(P_2(1),:)',X(P_2(3),:)'];
    
    %% Steuerstrom aus DGL berechnen
    
    for j=1:length(T)
        [~, I_1(j,:), I_2(j,:), F_1(j,:), F_2(j,:)] = sys_rotor_FEM_modal_JM_v021(T(j),Z(j,:)',sys,par,m,common,mag,komp,h);
    end
    
    %% Ergebnisse abspeichern
    
    data(1,:,i) = T;
    data(2,:,i) = s_1(:,1);
    data(3,:,i) = s_1(:,2);
    data(4,:,i) = s_2(:,1);
    data(5,:,i) = s_2(:,2);
    data(6,:,i) = s_S(:,1);
    data(7,:,i) = s_S(:,2);
    data(8,:,i) = I_1(:,1);
    data(9,:,i) = I_1(:,2);
    data(10,:,i) = I_2(:,1);
    data(11,:,i) = I_2(:,2);
    data(12,:,i) = Drehzahlen(i);
    data(13,:,i) = Z(:,1)*360/(2*pi);    
    
    frf(1,:,i) = T;
    frf(2:3,:,i)=par.Anregung_Weg_inertial_1;
    frf(4:5,:,i)=par.Anregung_Weg_inertial_2;
    frf(6,:,i) = s_1(:,1);
    frf(7,:,i) = s_1(:,2);
    frf(8,:,i) = s_2(:,1);
    frf(9,:,i) = s_2(:,2);
end

%% Stationäre Daten erzeugen

t_stationaer=10; %s

data_stationaer = data(:,t_stationaer/common.T:end,:);

%% Save

Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
save(['Simu_FEM_modal_v023_stat_' Datum '.mat'] , 'data','data_stationaer', 'frf');

%% Aufräumen
clearvars -except data_stationaer frf

data=data_stationaer;

%% Postprocessing starten
MLPS_Orbit_Darstellung_v01
%MLPS_FRF_Berechnen_v01
%MLPS_Magnetlager_Strom_FFT_v02
%Amplituden_Drehzahlen_Diagramm_JM_v01
%MLPS_Wasserfall_v01

