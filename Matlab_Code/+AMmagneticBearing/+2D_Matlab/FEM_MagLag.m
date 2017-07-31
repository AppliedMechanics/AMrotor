function [ Fx, Fy ] = FEM_MagLag( Position, IOben, IUnten, IRechts, ILink)
%   Name: FEM_MagLag.m

%   Beschreibung: berechnet mithilfe der PDE-Toolbox und der FE-Methode die
%   Kraft des Magnetlagers auf die Welle. Teilfunktionen sind in weitere
%   Skripts und Funktionen ausgegliedert

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE

%   Benoetigte Skripten/Funktionen: Geometrie_MagLag.m,
%%%%%%%%%%%%%

global debugMode  

%%%%%% Optionen
plotGeometry=1;        %0/1    
plotMesh=1;            %0/1
plotVektorPot=1;       %0/1
debugMode=0;           %0/1

%%%% TO DO / VERBESSERUNGEN

% 1) braucht es vlt ein "flag", wenn pos+versch==0 --> am Anfang vom Modul
% dann zurücksetzen!

% % "UEBERGABEWERTE" // braucht es nur, wenn dem Modul nichts uebergeben
% wird. Ansonsten auskommentieren!

Position=[0.0 0.00]*1E-3;
Verschiebung=[0.0 0.001]*1E-3; % Verschiebeweg: x, y

IOben=4.0; % Strom in den Spulen
IUnten=1.0;
IRechts=0;
ILinks=0;
%%%%%%%%%%% ENDE "UEBERGABEWERTE"




[mu_Luft,mu_Eisen,mu_Kupfer, n_Windungen,dTiefe]=Stoffwerte_MagLag();       % Stoffwerte sind nur fuer bessere Uebersichtlichkeit ausgegliedert
IArray=[IOben, IUnten, IRechts, ILinks];                                   % Fuer bessere Uebersichtlichkeit alle Stromwerte in einem Array


% (hier wird festgelegt, in welche Richtung verschoben wird; Einheitslänge, Richtung aus Position der Welle??)

% 1) nicht verschobene Welle
if debugMode
    fprintf('Beginn 1. Simulation: Welle nicht verschoben \n');
end
[model, dl, bt,ASpule, AxLimits,RB1,csgPole]=Geometrie_MagLag(Position,[0 0]);  % Erzeugen der Geometrie fuer Zustand 1 (vor der Verschiebung)
[model]=Init_MagLag(dl,bt,RB1,csgPole, mu_Luft,mu_Eisen,mu_Kupfer,n_Windungen,ASpule,model,IArray); 
[W1,A]=Solve_MagLag(model);
Plots_MagLag

% 2) Verschiebung in X-Richtung
if debugMode
    fprintf('Beginn 2. Simulation: Verschiebung in X-Richtung\n');
end
[model, dl, bt,ASpule, AxLimits,RB1,csgPole]=Geometrie_MagLag(Position,[Verschiebung(1) 0]);  % Erzeugen der Geometrie fuer Zustand 2 (vor der Verschiebung)
[model]=Init_MagLag(dl,bt,RB1,csgPole, mu_Luft,mu_Eisen,mu_Kupfer, n_Windungen,ASpule,model,IArray); 
[W2dx,A]=Solve_MagLag(model);
Plots_MagLag

% 3) Verschiebung in y-Richtung 
if debugMode
    fprintf('Beginn 3. Simulation: Verschiebung in Y-Richtung \n');
end
[model, dl, bt,ASpule, AxLimits,RB1,csgPole]=Geometrie_MagLag(Position,[0 Verschiebung(2)]);  % Erzeugen der Geometrie fuer Zustand 2 (vor der Verschiebung)
[model]=Init_MagLag(dl,bt,RB1,csgPole, mu_Luft,mu_Eisen,mu_Kupfer, n_Windungen,ASpule,model,IArray); 
[W2dy,A]=Solve_MagLag(model);
Plots_MagLag

% Ermittlung der Kraefte 
F(1)=(W2dx-W1)*dTiefe/Verschiebung(1);
F(2)=(W2dy-W1)*dTiefe/Verschiebung(2);


Fx=F(1);
Fy=F(2);

if debugMode
   fprintf('Energien: W1=%.4f, Wdx=%.4f, Wdy=%.4f \n',W1,W2dx,W2dy); 
   fprintf('Kräfte: Fx=%.4f, Fy=%.4f, \n',F(1),F(2)); 
end
if not(debugMode)
   fprintf('Kräfte: Fx=%.4f, Fy=%.4f, \n',F(1),F(2)); 
end
end

