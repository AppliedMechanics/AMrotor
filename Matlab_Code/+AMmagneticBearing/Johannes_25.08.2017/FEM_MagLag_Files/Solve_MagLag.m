function [ W,A, K ] = Solve_MagLag(model)
%   Name: Solve_MagLag.m

%   Beschreibung: Loest die pDGL mit konstantem Koeffizient fuer mu_Eisen;
%   K-Matrix als Rueckgabewert, weil fuer nichtlineare Simulation benoetigt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Stoffwerte_MagLag.m, Geometrie_MagLag.m, Init_MagLag.m

global debugMode        % globale Variable; dient als Schalter

 FEM=assembleFEMatrices(model);          % Erzeugen der K-Matrix
 K=FEM.K;
 J=FEM.F;
 
if debugMode
   fprintf('Löse PDGL und berechne Energie (linear) ... \n') 
end

result=solvepde(model);                 % Loesen des Problems
A=result.NodalSolution;                 % A ist magnetisches Vektorpotential
W=0.5*A'*J;

end

