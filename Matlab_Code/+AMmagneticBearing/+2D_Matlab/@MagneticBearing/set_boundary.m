function set_boundary( self)
% set_boundary ist eine Methode der Klasse MagneticBearing
% Anwenden der Randbedingungen auf die Ränder des Definitionsbereichs.
% Benoetigte Toolbox: PDE

applyBoundaryCondition(self.model,'dirichlet','Edge',self.cnfg.edges.Dirichlet,'r',0,'h',1);

end

