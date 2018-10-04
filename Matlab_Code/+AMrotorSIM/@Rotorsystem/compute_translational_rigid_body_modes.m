%Coumpute translational rigid body modes, which can be used to check the
%overall mass of rhe system using m_trans=u'*M*u

function U = compute_translational_rigid_body_modes(self)

n = 6*length(self.rotor.mesh.nodes);
U = zeros(n,3); % U=[U_x,U_y,U_z]
for i=1:6:n
U(i,1)   = 1;
U(i+1,2) = 1;
U(i+2,3) = 1;
end


end