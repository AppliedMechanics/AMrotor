function [ W, A, K, model, GitterZellen ] = FEM_MagLag( Position, Verschiebeweg, SpulenStrom, nonlinMu, K)
%   Name: FEM_MagLag.m

%   Beschreibung: Fuehrt die Routine der FEM-Simulation aus

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, Stoffwerte_MagLag.m, Geometrie_MagLag.m, Init_MagLag.m, Solve_MagLag.m
%   (SolveNonLin_MagLag.m)
%%%%%%%%%%%%%
global debugMode varMu plotGeometry plotMesh plotVektorPot  % Globale Variablen dienen als Schalter

% Erzeugen der Geometrie 
[model, dl, bt, ASpule, RB1, csgPole]=Geometrie_MagLag(Position,Verschiebeweg);  

%Initialisieren
[model,GitterZellen]=Init_MagLag(dl,bt,RB1,csgPole, ASpule,SpulenStrom,model,nonlinMu); 

% Loesen der pDGL
if nonlinMu
    [W,A]=SolveNonLin_MagLag(model,K);
    K=0;                                % die naechste Simulation ist wieder nicht-linear
else
    [W,A,K]=Solve_MagLag(model);
end

end