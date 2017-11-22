function [W] = solve( self )
% solve ist eine Methode der Klasse MagneticBearing
% Berechnung der magnetischen Kräfte auf den Rotor des Magnetlagers
% Benoetigte Toolbox: PDE
if isempty(self.model.InitialConditions) %% beschleunigt Algorithmus, daher auch bei linearer Berechnung
 newmodel=self.model;
 specifyCoefficients(newmodel,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Eisen),'a',0,'f',0,'Face',self.cnfg.faces.Eisen);       % Eisenkern und Rotorbuechse
 initialResult=solvepde(newmodel); 
 setInitialConditions(self.model,initialResult);
end

FEM=assembleFEMatrices(self.model);         % Erzeugen der K-Matrix
J=sparse(FEM.F);                            % sparse spart Speicher und Rechenzeit
result=solvepde(self.model);                % Loesen des Problems  

W=0.5*result.NodalSolution'*J;              % result.NodalSolution ist magnetisches Vektorpotential
% self.show_solution(result)
end


%% Kommentar zur Nichtlinearen Lösung
% Ohne setInitialCondition haben beide solver Probleme:
% FEM=assembleFEMatrices(self.model);   
    % Error using
    % pde.EquationModel/assembleFEMatricesInternal
    % (line 22)
    % PDE coefficients cannot be function of
    % solution or time.
    % 
    % Error in assembleFEMatrices (line 69)
    % FEMatricesOut =
    % assembleFEMatricesInternal(pdem,BCEnforcementOption); 
% result=solvepde(self.model);     
    % Error using
    % pde.EquationModel/solveStationaryNonlinear
    % (line 105)
    % Stepsize too small.
    % 
    % Error in pde.PDEModel/solvepde (line 77)
    %             u =
    %             self.solveStationaryNonlinear(coefstruct,
    %             u0);
% solvepde lässt sich durch die Senkung der Genauigkeitsanforderungen in
% self.model.SolverOptions zum Laufen bringen. AssembleFEMatrices auch
% durch hohe self.model.SolverOptions.MinStepSize nicht.
% Durch Hinweis auf https://de.mathworks.com/matlabcentral/answers/353514-solvepde-resulting-in-error-step-size-too-small
% habe ich eine erste Rechnung des Programmes durchlaufen lassen und dessen
% Ergebnis als Anfangswert festgelegt.

