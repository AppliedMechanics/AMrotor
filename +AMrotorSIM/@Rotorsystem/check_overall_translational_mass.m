% Licensed under GPL-3.0-or-later, check attached LICENSE file

function overall_mass = check_overall_translational_mass(self,U)
% Calculates the overall translational mass based on rigid body modes from the mass matrix: m_trans=u' x M x u, to compare it with the expected mass
%
%    :param U: Eigenvector matrix (only trans. rigid body)
%    :type U: matrix
%    :return: Overall translational mass

n_nodes=length(self.rotor.mesh.nodes);

M_disc=sparse(6*n_nodes,6*n_nodes);
K_disc=sparse(6*n_nodes,6*n_nodes);
G_disc=sparse(6*n_nodes,6*n_nodes);

for component = self.components
    
    if strcmp(component.type,'Disc')
        disc = component;
        
        disc.create_ele_loc_matrix;
        disc.get_loc_damping_matrix;
        disc.get_loc_gyroscopic_matrix;
        disc.get_loc_mass_matrix;
        disc.get_loc_stiffness_matrix;
        
        disc_node = self.rotor.find_node_nr(disc.position);
        L_ele = sparse(6,6*n_nodes);
        L_ele(1:6,(disc_node-1)*6+1:(disc_node-1)*6+6)=disc.localisation_matrix;
        
        M_disc = M_disc+L_ele'*disc.mass_matrix*L_ele;
        K_disc = K_disc+L_ele'*disc.stiffness_matrix*L_ele;
        G_disc = G_disc+L_ele'*disc.gyroscopic_matrix*L_ele;
    end
end

M = self.rotor.mass_matrix + M_disc;


U_x = U(:,1);
U_y = U(:,2);
U_z = U(:,3);


m_x = U_x'*M*U_x;
m_y = U_y'*M*U_y;
m_z = U_z'*M*U_z;

overall_mass.m_x = m_x;
overall_mass.m_y = m_y;
overall_mass.m_z = m_z;

end