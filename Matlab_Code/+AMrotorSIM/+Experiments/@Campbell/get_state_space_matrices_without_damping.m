function [A,B] = get_state_space_matrices_without_damping(obj,omega)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.entries = n.nodes*4*2; % 4 because of 4 dof per node and 2 because
                             % matrices will be stated as state space
                             % system
    rpm = omega/2/pi*60;
    G = obj.rotorsystem.systemmatrices.G;
    [M,~,K] = obj.add_seal_matrices(rpm);
        
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