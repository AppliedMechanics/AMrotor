function [W] = solve( self )
%SOLVE Summary of this function goes here
%   Detailed explanation goes here

 FEM=assembleFEMatrices(self.model);          % Erzeugen der K-Matrix
 J=FEM.F;

result=solvepde(self.model);                 % Loesen des Problems
A=result.NodalSolution;                 % A ist magnetisches Vektorpotential
W=0.5*A'*J;

end

