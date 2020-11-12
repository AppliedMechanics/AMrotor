function [u, ud] = find_state_vector(self, position, Z)
% Searches for the state-space vector of nodes regarding the position in the form u = [x; x_dot]
%
%    :param position: Position of interest along rotor axis 
%    :type position: double
%    :param Z: Global state-space vector
%    :type Z: vector
%    :return: Overall translational mass

% Licensed under GPL-3.0-or-later, check attached LICENSE file

node = self.rotor.find_node_nr(position);
dof_x = self.rotor.get_gdof('u_x',node);
dof_psi_z = self.rotor.get_gdof('psi_z',node);

% displacement
u = Z(dof_x:dof_psi_z);

% velocity
ud = Z(end/2+(dof_x:dof_psi_z));

% u_node = [u; u_dot];

end