function set_boundary( self)
%SET_BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

applyBoundaryCondition(self.model,'dirichlet','Edge',self.cnfg.edges.Dirichlet,'r',0,'h',1);

end

