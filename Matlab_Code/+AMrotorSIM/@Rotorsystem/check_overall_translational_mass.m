%Coumpute translational rigid body modes, which can be used to check the
%overall mass of rhe system using m_trans=u'*M*u

function overall_mass = check_overall_translational_mass(self,U)

U_x = U(:,1);
U_y = U(:,2);
U_z = U(:,3);
M = self.rotor.matrices.M;

m_x = U_x'*M*U_x;
m_y = U_y'*M*U_y;
m_z = U_z'*M*U_z;

overall_mass.m_x = m_x;
overall_mass.m_y = m_y;
overall_mass.m_z = m_z;

end