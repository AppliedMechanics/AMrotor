function [ W,A ] = Solve_MagLag( model )
%   Name: Geometrie_MagLag.m

%   Beschreibung: Erzeugt die Geometrie des Magnetlagers und definiert Koeffizienten / wird aus
%   FEM_MagLag.m aufgerufen

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
global debugMode

FEM=assembleFEMatrices(model);          % Erzeugen der K-Matrix

if debugMode
   fprintf('Löse PDGL ... \n') 
end

result=solvepde(model);                 % Loesen des Problems
A=result.NodalSolution;                 % A ist magnetisches Vektorpotential

if debugMode
   fprintf('Berechne Energie im Simulationsgebiet ... \n') 
end
W=0.5*A'*FEM.K*A;

end

