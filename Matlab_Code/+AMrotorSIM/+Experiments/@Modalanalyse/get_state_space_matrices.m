function [A,B] = get_state_space_matrices(obj,omega)
    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.entries = n.nodes*6*2; % 6 because of 6 dof per node and 2 because
                             % matrices will be stated as state space
                             % system, including torsional and axial modes
    rpm = omega/2/pi*60;
    G = obj.rotorsystem.systemmatrices.G;
    [M,D,K] = obj.add_seal_matrices(rpm);
    
    A = sparse(n.entries,n.entries);
    B = sparse(n.entries,n.entries);
    
    ind1 = 1:n.entries/2;
    ind2 = n.entries/2+1:n.entries;
    % set matrix A
    A(ind1,ind1) = sparse(M);
    A(ind2,ind2) = sparse(K);
    % set matrix B
    B(ind1,ind1) = sparse(omega*G+D);
    B(ind1,ind2) = sparse(K);
    B(ind2,ind1) = sparse(-K);
end