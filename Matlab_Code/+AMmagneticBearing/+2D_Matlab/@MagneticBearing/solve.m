function [W] = solve( self )
%SOLVE Summary of this function goes here
%   Detailed explanation goes here
FEM=assembleFEMatrices(self.model);         % Erzeugen der K-Matrix, ist abh�ngig vom Mesh
J=FEM.F;
result=solvepde(self.model);                 % Loesen des Problems
A=result.NodalSolution;                 % A ist magnetisches Vektorpotential
W=0.5*A'*J;
end
% in J gibt es keine Bereiche, die bei alle Wellenpositionen gleich sind.

