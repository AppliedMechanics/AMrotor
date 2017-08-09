function [ W,A ] = SolveNonLin_MagLag( model,K )
%   Name: Solve_MagLag.m

%   Beschreibung: Loest die pDGL mit nichtlinearem Koeffizient
%   (Permeabilitaet des Eisens). Dafuer wird die K-Matrix benoetigt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Stoffwerte_MagLag.m, Geometrie_MagLag.m, Init_MagLag.m, 

global debugMode        % globale Variable; dient als Schalter

if debugMode
   fprintf('Löse PDGL und berechne Energie (nichtlinear) ... \n') 
end

result=solvepde(model); 
A=result.NodalSolution;
% fprintf('Hier fehlt noch die tangentiale Steifigkeitsmatrix ...');
    % K= ...%
  W=0;

end

