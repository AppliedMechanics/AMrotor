%   Name: LoopKennfeld_MagLag.m

%   Beschreibung: Es wird je eine Schleife ueber Positionsbereich der Welle und Strombereich
%   in den Spulen durchlaufen und ein Kennfeld erstellt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,BerechneVerschiebung_MagLag.m, 
%       Geometrie_MagLag.m Stoffwerte_MagLag.m, Init_MagLag.m, Solve_MagLag.m, (SolveNonLin_MagLag.m)
%%%%%%%%%%%
clear; 
close all;

%%%%%% Optionen
global debugMode nonlinMu plotGeometry plotMesh plotVektorPot

plotGeometry=0;        %0/1    
plotMesh=0;            %0/1
plotVektorPot=0;       %0/1
nonlinMu=0;            %0/1 soll nichtlineares Modell der Permeabilität von Rotor und Stator verwendet werden?
debugMode=0;           %0/1
plotEnergy=1;          %0/1 plottet Energie der nicht verschobenen Welle als Funktion der Wellenposition für drei Differenzströme

%%%%% Ende Optionen
Verschiebeweg=[1e-4 1e-4]*1e-3;     % das soll noch raus!

PosY=(0:0.1:0.7);     % Position (Y) der Welle / mm
PosX=0;                % nur ein Wert / mm

I0=2.5;                 % Vormagnetisierungsstrom
IDiff=(2.5:-0.25:-2.5);    % Fuer Differenzenansteuerung

% Leere Matrizen fuer Ergebnisse
IDiffMat=zeros(length(IDiff),length(PosY));       % Strom der Differenzansteuerung
YMat=zeros(length(IDiff),length(PosY));        % Y-Position der Welle
FyMat=zeros(length(IDiff),length(PosY));       %????
W1Mat=zeros(length(IDiff),length(PosY));       % ???

str=strcat(pwd,'/FEM_MagLag_Files');        % In den Unterordner springen
addpath(genpath(str))

 for i=1:length(IDiff)                         % 1. Schleife: Differenzenstrom
    IOben=I0+IDiff(i);
    IRechts=0;
    IUnten=I0-IDiff(i);
    ILinks=0;
    SpulenStrom=[IOben IRechts IUnten ILinks];
    for j=1:length(PosY)                    % 2. Schleife: Y-Position der Welle
        fprintf('Simulation %i von %i \n', j+(i-1)*length(PosY), length(PosY)*length(IDiff));
        Position=[PosX PosY(j)]*1e-3;
        [ Kraefte, Energien, GitterZellen ]=pdvA_MagLag(Position,Verschiebeweg,SpulenStrom);        
        IDiffMat(i,j)=IDiff(i);
        YMat(i,j)=Position(2);
        FyMat(i,j)=Kraefte(2);
        W1Mat(i,j)=Energien(1);
    end
 end

%%%%% Plots
grey=[0.4 0.4 0.4];     % Grau als Linienfarbe fuer Plots

figure()
surf(YMat(1,:),IDiffMat(:,1),FyMat);
title('Kennfeld','Interpreter','latex');
xlabel('Differenzstrom / A', 'Interpreter', 'latex');
ylabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');

if plotEnergy
figure()
plot(YMat(1,:),W1Mat(round(0.5*length(IDiff)),:),'-k');
hold on
plot(YMat(1,:),W1Mat(round(0.25*length(IDiff)),:),'--','Color',grey);
plot(YMat(1,:),W1Mat(1,:),':','Color',grey),
xlabel('y-Position der Welle / m', 'Interpreter','latex');
ylabel('Energie im gesamten Simulationsgebiet / J', 'Interpreter', 'latex');
h=legend(['Energie für Ix=' num2str(IDiff(round(0.5*length(IDiff)))), ' A'],['Energie für Ix=' num2str(IDiff(round(0.25*length(IDiff)))) ' A'] ,['Energie für Ix=' num2str(IDiff(1)) ' A']);
set(h,'Interpreter','latex');
hold off
end