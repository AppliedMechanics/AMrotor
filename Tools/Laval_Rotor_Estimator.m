%% Laval-Rotor Abschätzungen
% Annahme des Euler-Bernoulli-Balken
% Anname des Lavalläufers: Gesamte Masse an der Scheibe

% Johannes Maierhofer
% 21.06.2016, 23.08.2017

%% Clean up

close all;
clear all;
clc;

%% Material Kennwerte
E = 211e9; %N/m^2
rho = 7850; %kg/m^3
g=9.81; %[m/s^2] Gravitationskonstante


%% Geometrische / Mechanische Parameter Rotor
rot.R = 4e-3; %m Radius der Welle

disc.R = 75e-3; %m
disc.d = 15e-3; %m
disc.m = disc.R^2*pi*disc.d*rho; %kg

rot.m = disc.m; %kg - Masse der Scheibe in der Mitte. Lagermassen vernachlässigt

rot.I_y = pi/4*rot.R^4 ; %Flächenträgheitsmoment der Welle

% Trägheitstensor der Scheibe
rot.I_xx0 = 0.0; %kg*m^2
rot.I_yy0 = 0.0; %kg*m^2
rot.I_zz0 = 0.0; %kg*m^2

rot.Lagerabstand = 0.6; %m
rot.a =  -0.4; %m Abstand linkes Lager vom Schwerpunkt inkl. Vorzeichen
rot.b = 0.2; %m Abstand rechts Lager vom Schwerpunkt inkl. Vorzeichen

%% Lasten

par.Epsilon = 0.001; %Grundunwucht
U = par.Epsilon*rot.m;

%% Simulationsparameter

time=0:0.001:1; %[s]

Drehzahlen = 1:50:1001; %[U/min]

%% Berechnung Systemeigenschaften
stiffness = (48*E*rot.I_y)/(rot.Lagerabstand)^2;
EF = sqrt(stiffness/rot.m)/(2*pi);

%% Berechnung stationäre Lösung

for i = 1:length(Drehzahlen)
    
    par.Omega = Drehzahlen(i)/60*2*pi; %rad/s

    Durchsenkung(i) = par.Epsilon*(par.Omega^2*rot.m)/((48*E*rot.I_y)/(rot.Lagerabstand)^2-par.Omega^2*rot.m);

    F_u(i) = (par.Epsilon + Durchsenkung(i))*par.Omega^2*rot.m;
    par.Anregung_rotor = [F_u(i), 0]; %Unwucht Drehzahlabhängig zum Anregungsvektor hinzufügen
    
end

%% Plots
% Verlauf der Amplitude des Schwerpunktes
figure
plot(Durchsenkung)

%% Ausgabe
diary(['log_',datestr(now,30),'.txt']);

disp(['-----------------------',datestr(today),'-------------------------'])
disp('Rotorsystem')
disp('Annahme des Euler-Bernoulli-Balken')
disp('Anname des Lavalläufers: Gesamte Masse an der Scheibe')
disp('--------- Geometrie ----------')
disp(['Rotorwelle: d=',num2str(2*rot.R),' m'])
disp(['Scheibe: d=',num2str(2*disc.R),' m -- m=',num2str(disc.m),' kg']);
disp('---------- Loads -------------')
disp(['Unwucht: U=',num2str(U),' Kgm'])
disp('------------ Systemeigenschaften ----------')
disp(['Eigenfrequenz: ', num2str(EF),' Hz']);
disp('------------ Amplitude --------------------')
for i=1:length(Drehzahlen)
    disp([num2str(Drehzahlen(i)),' U/min -- u=',num2str(Durchsenkung(i)),' m']);
end
disp('----------------------------End-----------------------------')

diary off