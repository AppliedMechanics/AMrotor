function set_boundary_Displace( self,edges )
%SET_BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

applyBoundaryCondition(self.model,'dirichlet','Edge',edges.Dirichlet,'r',0,'h',1);

end

