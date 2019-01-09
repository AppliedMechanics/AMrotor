function [u, ud, udd] = find_state_vector(self, position, Z, qdotdot)
% only for state-space in the form u = [x; x_dot]

node = self.rotor.find_node_nr(position);
dof_x = self.rotor.get_gdof('u_x',node);
dof_psi_z = self.rotor.get_gdof('psi_z',node);

% displacement
u = Z(dof_x:dof_psi_z);

% velocity
ud = Z(end/2+(dof_x:dof_psi_z));

% acceleration
udd = qdotdot(dof_x:dof_psi_z);

% u_node = [u; u_dot];

end