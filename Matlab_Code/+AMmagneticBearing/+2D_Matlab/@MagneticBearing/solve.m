function [W] = solve( self )
% solve ist eine Methode der Klasse MagneticBearing
% Berechnung der magnetischen Kräfte auf den Rotor des Magnetlagers
% Benoetigte Toolbox: PDE
FEM=assembleFEMatrices(self.model);         % Erzeugen der K-Matrix
J=sparse(FEM.F);                            % sparse spart Speicher und Rechenzeit
result=solvepde(self.model);                % Loesen des Problems  

W=0.5*result.NodalSolution'*J;              % result.NodalSolution ist magnetisches Vektorpotential
% self.show_solution(result)
end
