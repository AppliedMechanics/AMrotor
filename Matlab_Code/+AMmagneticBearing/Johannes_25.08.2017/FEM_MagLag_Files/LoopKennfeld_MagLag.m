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
% 
% %%%%%% Optionen
%global debugMode varMu plotGeometry plotMesh plotVektorPot
% 
plotGeometry=0;        %0/1    
plotMesh=0;            %0/1
plotVektorPot=0;       %0/1
varMu=1;            %0/1 soll nichtlineares Modell der Permeabilität von Rotor und Stator verwendet werden?
debugMode=0;           %0/1
plotEnergy=0;          %0/1 plottet Energie der nicht verschobenen Welle als Funktion der Wellenposition für drei Differenzströme
% 
%%%%% Ende Optionen
% Verschiebeweg=[1e-4 1e-4]*1e-3;     % das soll noch raus!

PosY=(-0.7:0.1:0.7);     % Position (Y) der Welle / mm
PosX=0;                % nur ein Wert / mm

I0=2.5;                 % Vormagnetisierungsstrom
IDiff=(-2.5:0.25:2.5);    % Fuer Differenzenansteuerung

% Leere Matrizen fuer Ergebnisse
IDiffMat=zeros(length(PosY),length(IDiff));       % Strom der Differenzansteuerung
YMat=zeros(length(PosY),length(IDiff));        % Y-Position der Welle
FyMat=zeros(length(PosY),length(IDiff));       %????
W1Mat=zeros(length(PosY),length(IDiff));       % ???

str=strcat(pwd,'/FEM_MagLag_Files');        % In den Unterordner springen
addpath(genpath(str))

 for i=1:length(IDiff)                         % 1. Schleife: Differenzenstrom
    IOben=I0+IDiff(i);
    IRechts=0;
    IUnten=I0-IDiff(i);
    ILinks=0;
    SpulenStrom=[IOben IRechts IUnten ILinks];
    parfor j=1:length(PosY)                    % 2. Schleife: Y-Position der Welle
        fprintf('Simulation %i von %i \n', j+(i-1)*length(PosY), length(PosY)*length(IDiff));
        Position=[PosX PosY(j)]*1e-3;
        [ Kraefte, Energien, GitterZellen ]=pdvA_MagLag(Position,SpulenStrom,varMu);        
        IDiffMat(j,i)=IDiff(i);
        YMat(j,i)=Position(2);
        FyMat(j,i)=Kraefte(2);
        W1Mat(j,i)=Energien(1);
    end
 end

%%%% Plots
grey=[0.4 0.4 0.4];     % Grau als Linienfarbe fuer Plots

figure()
surf(IDiffMat(1,:),YMat(:,1),FyMat);
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

% %%%%% IMPORT DER ANSYS DATEN
% data=csvread('simforceoutput.csv');
% resultmatrix=data;
% %Skalierung auf Lagerbreite
% 
% xscale=csvread('mgdat1.csv');       % Differenzenstrom
% yscale=csvread('mgdat2.csv');       % Y-Positino
% [xpkt, ypkt]=meshgrid(xscale,yscale);
% 
% %meshgrid fuer plot
% %xscale=itIsy;
% %yscale=ity
% %[xpkt ypkt]=meshgrid(itIsy,ity);
% 
% %% Plot erstellen
% figure();
% pos=1;
% for n1=1:length(xscale)
%     plotdata(:,n1)=resultmatrix(pos:pos+length(yscale)-1,8);
%     pos=pos+length(yscale);
% end
% plotdata=plotdata.*0.032; % Länge des Magnetlagers
% mesh(xpkt,ypkt,plotdata)
% axis tight;
% title('Kennfeld des Magnetlagers, analytisch berechnet, Vormagnetisierungsstrom 5A');
% xlabel('Steuerstrom in y-Richtung in A');
% ylabel('y-Position in mm');
% zlabel('Kraft in y-Richtung in N');

%%%% Differenz der Simulationswerte: Ansys-Matlab
% FyDiff=plotdata-FyMat;
% 
% figure()
% surf(IDiffMat(1,:),YMat(:,1),FyDiff);
% title('Differenz der Kennfelder: "Ansys-Matlab"','Interpreter','latex');
% xlabel('Differenzstrom / A', 'Interpreter', 'latex');
% ylabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
% zlabel('Differenz der Kraft in y-Richtung / N','Interpreter','latex');
% 
% % Prozent der Fehler
% fehlerProzent=(abs(FyMat-plotdata))./abs(FyMat)*100;
% figure();
% surf(IDiffMat(1,:),YMat(:,1),fehlerProzent);
% set(gca,'zlim',[0 100]);