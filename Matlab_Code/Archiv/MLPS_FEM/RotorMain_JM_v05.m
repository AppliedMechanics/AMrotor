%% *Modellierung Rotor mit FEM*
%
% *Basierend auf: Rotormodell Markus Roßner, Christian Wagner, AM*
%
% Johannes Maierhofer
% Angewandte Mechanik TUM
% 23.06.2016
%
% Version 04: Neue Werte für Magnetlagerkraft
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

%% Clean up
clc
clear all
close all

addpath(strcat(fileparts(which(mfilename)),'/FEMRotor'));
addpath(strcat(fileparts(which(mfilename)),'./Postprocess'));

%% Allgemeine Parameter
%common.g=9.81; %m/s^2 Gravitationskonstante

common.T = 1e-3; %s Schrittweite
common.Tend = 0.5; %s Simulationsdauer

Drehzahlen = [0:250:3001]; %U/min

%% Magnetlager Kennwerte

% Reglerparameter
mag.Kp=8000;% A/mm
mag.Ki=1500;  % A/mm*s
mag.Kd=5;   % A*s/mm

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


%% FEM-ANALYSE EINES ROTORS
% 13.01.2016
%
% - Modellierung des Rotors als Bernoulli-Balken
% - Balken-Standard-KOS
% - Auswertung der FE in ROTIERENDEM KOS !
% - bei x=0 Festlager, bei x=Laenge Loslager
% - Realisierung durch Streichen dof, allerdings erst direkt vor Berechnung
% - Reihenfolge der dofs: Verschiebung in y, Drehung um z, Verschiebung in
% z, Drehung um y, Zug/Druck-Dehnung, Torsion
% - keine weiteren Scheiben


%Wellengeometrie in ErzeugeKM eintragen

%Steifigkeits, Massenmatrix und Dämpfung erzeugen
[sys,par]=ErzeugeKM();
%

%Dämpfung, Diskret
%Eingabe [d11 d12 d21 d22][Position]
% DampCoeff = [100 0 0 100];
% DampPos = [0.35];
% Dl = AssembleMatrixkoeffizientenCW(par,DampCoeff,DampPos);
% D = D+Dl;

%% Modale Reduktion herausnehmen
% Schlecht besetzte Matrizen vermeiden
% Ursache: Weglassen der Lagersteifigkeiten


            % %% Eigenwerte/Vektoren
            
%             par.Moden = 10;
%             [EV,EW] = eigs(sys.K,sys.M,par.Moden,'sm');
%             EW= diag(EW);
%             m.EV = EV;
%             m.ew = EW;
%             
%             % Darstellung der Eigenmoden (unsortiert):
%             figure;
%             for i=1:par.Moden
%             plot(EV(1:2:end/2,i))
%             hold on;
%             legende{i}=['Mode nr.: ' num2str(i)];
%             end
%             title('Eigenmoden der Welle in x-Richtung');
%             ylabel('Relative Überhöhung');
%             xlabel('Position entlang der Welle');
%             legend(legende, 'show');

%%

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

Unwucht1 = [0.35,1.1e-3,0]; %Parameter in Form [Position, m*e, psi], m klein gegenueber Rotormasse
[h] = Ergaenze_Unwuchtmasse(h,par,Unwucht1);

%% Solve

%Zustand 0 für alle setzen
Z0 = zeros(8*par.nKnoten+2+4,1).';
time=[0:common.T:common.Tend];

%Angangszustand auslenken
%Z0(2+1:2:2*par.nKnoten+2) = 0.0005;               % Auslenkung in x-Richtung
%Z0(2*par.nKnoten+2+1:2:4*par.nKnoten+2) = 0.0005; % Auslenkung in y-Richtung
%Z0(2+4*par.nKnoten+1:2:6*par.nKnoten+2) = 0.5;
%Z0(2+6*par.nKnoten+1:2:8*par.nKnoten+2) = 0.5;

VZ= zeros(length(time),length(Z0),length(Drehzahlen)); % Ergebnisvektor vorbelegen

for i =1:length(Drehzahlen)
    
    
    Z0(2)=Drehzahlen(1,i)/60*2*pi; % Anfangswert der Drehzahl korrekt setzen.
%    omi = Drehzahlen(1,i);
    
    m=[];

    %==============================================================================
    options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6, 'OutputFcn','odeprint','OutputSel',[2]);
    [T,Z] = ode45(@sys_rotor_FEM_JM_v04,time,Z0,options,sys,par,m,common,mag,h);
    
    VZ(:,:,i)=Z;
    
    %% Rücktransformation
    
    %Position der Sensoren auswählen und passenden Knoten dazu finden.
    Position_1=0.1; %m
    [P_1] = SucheKnotenZuPositionCW(par,Position_1);%x beta y alpha
    Position_S=0.35; %m
    [P_S] = SucheKnotenZuPositionCW(par,Position_S);%x beta y alpha
    Position_2=0.6; %m
    [P_2] = SucheKnotenZuPositionCW(par,Position_2);%x beta y alpha
    
      s_1 = [Z(:,P_1(1)),Z(:,P_1(3))];
      s_S = [Z(:,P_S(1)),Z(:,P_S(3))];
      s_2 = [Z(:,P_2(1)),Z(:,P_2(3))];
    
    %% Steuerstrom aus DGL berechnen
    
    for j=1:length(T)
        [~, I_1(j,:), I_2(j,:), F_1(j,:), F_2(j,:)] = sys_rotor_FEM_JM_v04(T(j),Z(j,:)',sys,par,m,common,mag,h);
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
    
end

%%Save

Datum = datestr(datetime('now'));
Datum(ismember(Datum,' :')) = ['-'];
save(['Simu_FEM_v05__' Datum '.mat'] , 'data');

%% Postprocessing starten
MLPS_Orbit_Darstellung_v01
Amplituden_Drehzahlen_Diagramm_JM_v01
MLPS_Wasserfall_v01
