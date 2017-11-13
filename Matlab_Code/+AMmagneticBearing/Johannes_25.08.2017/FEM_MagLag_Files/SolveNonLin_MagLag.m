function [ W,A ] = SolveNonLin_MagLag( model,model_lin )
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

FEM_matrices = assembleFEMatrices(model_lin);

% result_lin = solvepde(model_lin);
% setInitialConditions(model,result_lin);

result=solvepde(model); 
A=result.NodalSolution;

    J=FEM_matrices.F;
    W = 0.5*A'*J;

end

