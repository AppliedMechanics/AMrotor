function U = compute_translational_rigid_body_modes(self)
% Builds the translational rigid body modes matrix u, which can be used to check the overall mass of the system using m_trans=u' x M x u
%
%    :return: Rigid body mode matrix u (only trans. rigid body)

% Licensed under GPL-3.0-or-later, check attached LICENSE file

n = 6*length(self.rotor.mesh.nodes);
U = zeros(n,3); % U=[U_x,U_y,U_z]
for i=1:6:n
U(i,1)   = 1;
U(i+1,2) = 1;
U(i+2,3) = 1;
end


end