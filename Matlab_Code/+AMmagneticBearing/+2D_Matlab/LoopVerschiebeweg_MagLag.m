%   Name: Loop_MagLag.m

%   Beschreibung: Es wird je eine Schleife ueber Positionsbereich der Welle und Strombereich
%   in den Spulen durchlaufen und ein Kennfeld erstellt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Skripten/Funktionen: FEM_MagLag, Geometrie_MagLag,
%   Init_MagLag, Solve_MagLag, Plots_MagLag, BerechneVerschiebung_MagLag
%%%%%%%%%%%
clear all; 
close all;

%%%%%% Optionen
global debugMode nonlinMu plotGeometry plotMesh plotVektorPot

plotGeometry=0;        %0/1    
plotMesh=0;            %0/1
plotVektorPot=0;       %0/1
nonlinMu=0;            %0/1     soll nichtlineares Modell der Permeabilität von Rotor und Stator verwendet werden?
debugMode=0;           %0/1
%%%%% Ende Optionen

% Setup
dV=linspace(1e-9,1e-5,2500);    % Verschiebeweg in m
Position=[0 0.5]*1e-3;          % Wellenposition (x, y) in metern

I0=2.5;                         % Vormagnetisierungsstrom in A
IDiff=1;                           % Differenzenstrom in A

IOben=I0+IDiff;                    % Strom in den Spulen
IRechts=0;
IUnten=I0-IDiff;
ILinks=0;
SpulenStrom=[IOben IRechts IUnten ILinks];

% Anlegen der leeren Matrizen
VyMat=zeros(length(dV),1);              % Fuer Verschiebeweg
FMat=zeros(length(dV),2);               % Fuer Kraft (x, y)
GitterZellenMat=zeros(length(dV),3);    % Anzahl Gitterzellen für die 3 Simulationen

str=strcat(pwd,'/FEM_MagLag_Files');    % Pfad in den Unterordner (dort liegen die Berechnungs-Funktionen)
addpath(genpath(str))

for i=1:length(dV)                      % Schleife ueber alle Verschiebungen
    Verschiebeweg=[dV(i) dV(i)];        % gleicher Verschiebeweg in x- und y-Richtung
    fprintf('Simulation %i von %i \t', i, length(dV));
    fprintf('Verschiebeweg: %.7f mm \t', dV(i)*1e3);
    
    [ Kraefte, Energien, GitterZellen ]=pdvA_MagLag(Position,Verschiebeweg,SpulenStrom);        
    VyMat(i)=Verschiebeweg(2);
    FMat(i,:)=Kraefte;
    GitterZellenMat(i,:)=GitterZellen;

    fprintf('Kräfte: Fx=%.4f, Fy=%.4f, \n',Kraefte(1),Kraefte(2)); 

end

%%%%%%%%%% Plots
grey=[0.4 0.4 0.4];     % Grau als Linienfarbe fuer Plots

figure()                % Plot: Kraft in X-Richtung
title('Kraft in x-Richtung','Interpreter','latex');
xlabel('Verschiebeweg / m', 'Interpreter', 'latex');
yyaxis left
plot(VyMat,FMat(:,1),'-k');
ylabel('Kraft in x-Richtung / N', 'Interpreter', 'latex');
ax=gca;
ax.YColor='k';
hold off
yyaxis right
hold on
plot(VyMat,GitterZellenMat(:,1),':','Color',grey);      % Netzelemente fuer Simulationen der nichtausgelenkten Welle
plot(VyMat,GitterZellenMat(:,2),'--','Color',grey);     % Netzelemente fuer Simulation der Auslenkung in X-Richtung
ylabel('Anzahl der Netzelemente / -','Interpreter','latex');
h=legend('Kraft in x-Richtung','Netzelemente vor Verschiebung','Netzelemente nach Verschiebung');
set(h,'Interpreter','latex');
ax=gca;
ax.XColor='k';
ax.YColor='k';
hold off

figure()              % Plot: Kraft in Y-Richtung
title('Kraft in y-Richtung','Interpreter','latex');
yyaxis left
plot(VyMat,FMat(:,2),'-k');
xlabel('Verschiebeweg / m', 'Interpreter', 'latex');
ylabel('Kraft in y-Richtung / N', 'Interpreter', 'latex','Color','black');
ax=gca;
ax.YColor='k';
hold off
yyaxis right
hold on
plot(VyMat,GitterZellenMat(:,1),':','Color',grey);      % Netzelemente fuer Simulationen der nichtausgelenkten Welle
plot(VyMat,GitterZellenMat(:,3),'--','Color',grey);     % Netzelemente fuer Simulation der Auslenkung in X-Richtung
ylabel('Anzahl der Netzelemente / -','Interpreter','latex');
h=legend('Kraft in y-Richtung','Netzelemente vor Verschiebung','Netzelemente nach Verschiebung');
set(h,'Interpreter','latex');
ax=gca;
ax.XColor='k';
ax.YColor='k';
hold off
