function [F] = get_sealsNonLinear_force(sealNonLinear,res,rotorsystem)


    seal_node = rotorsystem.rotor.find_node_nr(sealNonLinear.position);
    sealNonLinear.create_ele_loc_matrix;
    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=sealNonLinear.localisation_matrix;
    
    dof_u_x = rotorsystem.rotor.get_gdof('u_x',seal_node);
    dof_psi_z = rotorsystem.rotor.get_gdof('psi_z',seal_node);
    node.q = Z(dof_u_x:dof_psi_z);
    node.qd = Z(6*n_nodes+(dof_u_x:dof_psi_z));
    
    sealNonLinear.get_loc_system_matrices(node);
    
    M_seal = M_seal+L_ele'*sealNonLinear.mass_matrix*L_ele;
    K_seal = K_seal+L_ele'*sealNonLinear.stiffness_matrix*L_ele;
    D_seal = D_seal+L_ele'*sealNonLinear.damping_matrix*L_ele;
    
    F = M_seal*res.qdd + D_seal*res.qd + K_seal*res.q;


end

