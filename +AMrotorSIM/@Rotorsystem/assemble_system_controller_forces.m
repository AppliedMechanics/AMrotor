function h = assemble_system_controller_forces(self,t,Z)
% Adds the controller force to the load vector ????
% 
%    :parameter t: time step
%    :parameter Z: state-space vector [x; x_dot]
%    :return: Load vector h


n_nodes=length(self.rotor.mesh.nodes);
h = sparse(6*n_nodes,1);

for cntr = self.pidControllers
    
    n_nodes=length(self.rotor.mesh.nodes);
    node = self.rotor.find_node_nr(cntr.position);
    glob_dof = self.rotor.get_gdof(cntr.direction,node);
    
    % localisation matrix is only a vector
    L_glob = sparse(1,6*n_nodes);
    L_glob(glob_dof) = 1;
    
    [displacementCntrNode, ~] = self.find_state_vector(cntr.position, Z);
    force = cntr.get_controller_force(t,displacementCntrNode);
    
    h = h + L_glob' * force;
    
end



end