function [M_Comp,D_Comp,G_Comp,K_Comp]= get_component_matrices(self,components,rpm)
% Extracts the specific component matrices (M,D,G,K)
%
%    :param components: Desired component object
%    :type components: object
%    :param rpm: Rotational speed
%    :type rpm: double
%    :return: Component matrices (M,D,G,K)

% Licensed under GPL-3.0-or-later, check attached LICENSE file

n_nodes=length(self.rotor.mesh.nodes);

M_Comp =sparse(6*n_nodes,6*n_nodes);
D_Comp =sparse(6*n_nodes,6*n_nodes);
G_Comp =sparse(6*n_nodes,6*n_nodes);
K_Comp =sparse(6*n_nodes,6*n_nodes);

for Component = components
    Component.create_ele_loc_matrix;
    Component.get_loc_mass_matrix(rpm);
    Component.get_loc_damping_matrix(rpm);
    Component.get_loc_gyroscopic_matrix(rpm);
    Component.get_loc_stiffness_matrix(rpm);
    
    component_node = self.rotor.find_node_nr(Component.position);
    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(component_node-1)*6+1:(component_node-1)*6+6)=Component.localisation_matrix;
    
    M_Comp  = M_Comp +L_ele'*Component.mass_matrix*L_ele;
    D_Comp  = D_Comp +L_ele'*Component.damping_matrix*L_ele;
    G_Comp  = G_Comp +L_ele'*Component.gyroscopic_matrix*L_ele;
    K_Comp  = K_Comp +L_ele'*Component.stiffness_matrix*L_ele;
end

end