%   Name: BerechneKraft_MagLag.m

%   Beschreibung: Berechnung der Kraft in x- und y-Richtung fuer eine
%   gegebene Wellenposition

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,BerechneVerschiebung_MagLag.m, 
%       Geometrie_MagLag.m Stoffwerte_MagLag.m, Init_MagLag.m, Solve_MagLag.m, (SolveNonLin_MagLag.m)
%%%%%%%%%%%
clear; 
close all;

%%%%%% Optionen
global debugMode plotGeometry plotMesh plotVektorPot

plotGeometry=1;        %0/1    
plotMesh=1;            %0/1
plotVektorPot=1;       %0/1
varMu=1;               %0/1 soll nichtlineares Modell der Permeabilität von Rotor und Stator verwendet werden?
debugMode=1;           %0/1
printErgebnis=1;       %0/1 Ausgabe der Kraefte und Energien in der Konsole

%%%%% Ende Optionen
% Verschiebeweg=[1 1]*1e-6;     % das soll noch raus!
Position=[0.0 0.4]*1e-3;                % das bleibt drinnen

I0=2.5;                 % Vormagnetisierungsstrom
IDiff=1;                % Fuer Differenzenansteuerung

IOben=I0+IDiff;
IRechts=0;
IUnten=I0-IDiff;
ILinks=0;

SpulenStrom=[IOben IRechts IUnten ILinks];

str=strcat(pwd,'/FEM_MagLag_Files');            % Pfad in den Unterordner 
addpath(genpath(str))

[ Kraefte, Energien, GitterZellen ]=pdvA_MagLag(Position,SpulenStrom,varMu);

if debugMode || printErgebnis
    fprintf('Energien: W1=%.6f J, Wdx=%.6f J, Wdy=%.6f J \n',Energien(1),Energien(2), Energien(3)); 
    fprintf('Kräfte: Fx=%.4f N, Fy=%.4f N \n',Kraefte(1),Kraefte(2)); 
 end 
