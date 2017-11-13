function [ W, A, model, GitterZellen ] = FEM_MagLag( Position, Verschiebeweg, SpulenStrom, nonlinMu)
%   Name: FEM_MagLag.m

%   Beschreibung: Fuehrt die Routine der FEM-Simulation aus

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, Stoffwerte_MagLag.m, Geometrie_MagLag.m, Init_MagLag.m, Solve_MagLag.m
%   (SolveNonLin_MagLag.m)
%%%%%%%%%%%%%

% Erzeugen der Geometrie 
[model, dl, bt, ASpule, RB1, csgPole]=Geometrie_MagLag(Position,Verschiebeweg);
[model_lin, dl_lin, bt_lin, ASpule_lin, RB1_lin, csgPole_lin]=Geometrie_MagLag(Position,Verschiebeweg);  

%Initialisieren
[model,GitterZellen]=Init_MagLag(dl,bt,RB1,csgPole, ASpule,SpulenStrom,model,nonlinMu); 
[model_lin,GitterZellen_lin]=Init_MagLag(dl_lin,bt_lin,RB1_lin,csgPole_lin, ASpule_lin,SpulenStrom,model_lin,0); 

% Loesen der pDGL
if nonlinMu
    [W,A]=SolveNonLin_MagLag(model,model_lin);
else
    [W,A]=Solve_MagLag(model);
end

end