%function [Zeit,x,y,phi] = RitzSimMain(m1,phi1,m2,phi2,Omega0)

addpath(strcat(fileparts(which(mfilename)),'/RitzSim'));

load wagner2.mat
%load Systemmatrizen.mat
g=0;
E=210e9;
phi0 = 0;
Omega0 = 150;

% =========================================================================
% Belastungen
% =========================================================================

% Definition Vektoren
h = zeros(4*length(Knoten),1); %konstante statorfeste Last
h_ZPsin = h; %Zentripetal-Beschleunigungen
h_ZPcos = h;
h_DBsin = h; %Drehbeschleunigungen
h_DBcos = h;
h_sin = h;
h_cos = h;

% Unwuchtmassen
[h_ZPsin, h_ZPcos, h_DBsin, h_DBcos] = Ergaenze_Unwuchtmasse(h_ZPsin, h_ZPcos, h_DBsin, h_DBcos, Knoten, [0.2,0,pi/2]); %Parameter in Form Position, m*e, psi, m klein gegenüber Rotormasse

% Wellenschlag
% Fuer Schlag wird Welle mit durchgehendem Durchmesser 25 modelliert-> verringert Momentenspruenge, Fehler vernachlaessigbar
% Entspricht Geometrie bei Schlagmessung, mit versteifenden Scheiben aendert sich Amplitude
Geometrie3 = [0, 0.0125; 0.5, 0];
[Flaechentraegheit3] = BerechneFlaechenmomente(Geometrie3);
K_B_Schlag = Berechne_K_B(Geometrie3, Flaechentraegheit3, E, Knoten);
[h_sin, h_cos] = ErgaenzeSchlag(h_sin, h_cos, Knoten, zLager1, zLager2, K_B_Schlag, 400, pi/2); %Pruefstand mit Schlag von 1e-4

% Testlast: Mittige Kraft
F1x = 0; F1y = 0; F1_Position = 0.15;
[h] = Ergaenze_Inertialfeste_Kraft(h, F1x, F1y, F1_Position, Knoten);

% Testlast: entgegengesetzte Momente an Enden
M1x = 0; M1y = 0; M1_Position = 0;
[h] = Ergaenze_Inertialfestes_Moment(h, M1x, M1y, M1_Position, Knoten);
M2x = -M1x; M2y = -M1y; M2_Position = Geometrie(end,1);
[h] = Ergaenze_Inertialfestes_Moment(h, M2x, M2y, M2_Position, Knoten);

% Testlast: Streckenlast
for n2 = 1:length(Geometrie)-1
    p1x = 0;
    p1y = -g*rho*pi*Geometrie(n2,2)^2;
    p1Start = Geometrie(n2,1);
    p1End = Geometrie(n2+1,1); %Start und Ende muessen auf Knoten liegen
    [h] = Ergaenze_Inertialfeste_Streckenlast(h, p1x, p1y, p1Start, p1End, Knoten);
end

% Modaltransformation der Belastungen:
h_m = EV2.'*h;
h_ZPcos_m = EV2.'*h_ZPcos;
h_ZPsin_m = EV2.'*h_ZPsin;
h_DBsin_m = EV2.'*h_DBsin;
h_DBcos_m = EV2.'*h_DBcos;
h_sin_m = EV2.'*h_sin;
h_cos_m = EV2.'*h_cos;


% =========================================================================
% Integration der DGL
% =========================================================================

tic

Startvektor = zeros(2*Moden+2).';
Startvektor(1) = phi0;
Startvektor(2) = Omega0;
Startvektor(Moden+3) = 1e-7; %hilft spaeter bei Winkelbestimmung

% Systemmatrix und Kraftvektor bei konstanter Drehzahl

AnzahlAbschnitt = 10;
LaengeAbschnitt = 0.2;
dt = 1e-4;
for n = 1:AnzahlAbschnitt %Integration in mehreren Abschnitten erlaubt es, Speicherplatz freizugeben
    Zeitintervall = [(n-1)*LaengeAbschnitt n*LaengeAbschnitt];
    Zwischenloesung = ode45(@DGL, Zeitintervall, Startvektor, [], Jzz, Moden, K_m, KDI_m, Nn_m, DDI_m, DDA_m, Gn_m, h_m, h_ZPsin_m, h_ZPcos_m, h_DBsin_m, h_DBcos_m, h_sin_m, h_cos_m);
    Zwischenzeit = Zeitintervall(1) : dt : Zeitintervall(2);
    if n == 1
        Zustand = deval(Zwischenloesung, Zwischenzeit);
        Zeit = Zwischenzeit;
    else
        Zustand = [Zustand, deval(Zwischenloesung, Zwischenzeit(2:end))]; %#ok<AGROW>
        Zeit = [Zeit, Zwischenzeit(2:end)]; %#ok<AGROW>
    end
    clear Zwischenloesung %Freigabe Speicherplatz durch Löschen nicht mehr benötigter Daten
    Startvektor = Zustand(:,end);
end

Drehung = Zustand(1:2,:);
ModaleBiegung = Zustand(3:end,:);
clear Zustand

toc

[x,y] = BerechneOrbit(0.304, Knoten, ModaleBiegung, EV2, Moden);

% plot(Zeit,x,Zeit,y)
hold on
plot(Zeit,x,'r',Zeit,y,'k')