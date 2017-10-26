function set_boundary( self,edges )
%SET_BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

applyBoundaryCondition(self.model,'dirichlet','Edge',edges.Dirichlet,'r',0,'h',1);
%applyBoundaryCondition(self.model,'neumann','Edge',edges.Neumann,'r',0,'h',1);

% Problemstellung	    Dirichlet-Randbedingung/Funktionswert	Neumann-Randbedingung
% statisches Problem	Auflagerbedingung/Verschiebung	        Kraft
end

