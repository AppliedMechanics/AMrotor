function [A,B] = get_state_space_matrices_without_damping(obj,omega)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.entries = n.nodes*4*2; % 4 because of 4 dof per node and 2 because
                             % matrices will be stated as state space
                             % system
    rpm = omega/2/pi*60;
    M = obj.rotorsystem.systemmatrices.M;
    K = obj.rotorsystem.systemmatrices.K;
    G = obj.rotorsystem.systemmatrices.G;
    
    %==================================================================
    % Seal-coefficients dependent on rotational speed
    n_nodes=length(obj.rotorsystem.rotor.mesh.nodes);
    M_seal = sparse(6*n_nodes,6*n_nodes);
    D_seal = sparse(6*n_nodes,6*n_nodes);
    K_seal = sparse(6*n_nodes,6*n_nodes);
       for seal = obj.rotorsystem.seals 
            seal.create_ele_loc_matrix;
            seal.get_loc_system_matrices(rpm);

            seal_node = obj.rotorsystem.rotor.find_node_nr(seal.position);
            L_ele = sparse(6,6*n_nodes);
            L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=seal.localisation_matrix;

            M_seal = M_seal+L_ele'*seal.mass_matrix*L_ele;
            K_seal = K_seal+L_ele'*seal.stiffness_matrix*L_ele;
            D_seal = D_seal+L_ele'*seal.damping_matrix*L_ele;
            
            M = M + M_seal;
            %D = D + D_seal;
            K = K + K_seal;
       end
    %==================================================================
        
        
    ind_red = 1:n.nodes*6;
    ind_z = 3:6:n.nodes*6;
    ind_psi_z = 6:6:n.nodes*6;
    ind_red = setdiff(ind_red,[ind_z,ind_psi_z]); % remove dof u_z psi_z for compatibility, no information on torsional and axial eigenbehaviour 
    M = M(ind_red,ind_red);
    K = K(ind_red,ind_red);
    G = G(ind_red,ind_red);
    A = sparse(n.entries,n.entries);
    B = sparse(n.entries,n.entries);
    
    ind1 = 1:n.entries/2;
    ind2 = n.entries/2+1:n.entries;
    % set matrix A
    A(ind1,ind1) = sparse(M);
    A(ind2,ind2) = sparse(K);
    % set matrix B
    B(ind1,ind1) = sparse(omega*G);
    B(ind1,ind2) = sparse(K);
    B(ind2,ind1) = sparse(-K);
end