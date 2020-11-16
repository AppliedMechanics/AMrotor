function [A,B] = get_state_space_matrices(obj,omega)
% Builds state space matrices of form A=[M, 0;0, K] and B=[omega*G+C, K;K, 0]
%
%    :param omega: Angular velocity
%    :type omega: double
%    :return: State space matrices A, B

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    n.nodes = length(obj.rotorsystem.rotor.mesh.nodes);
    n.entries = n.nodes*6*2; % 6 because of 6 dof per node and 2 because
                             % matrices will be stated as state space
                             % system, including torsional and axial modes

    [M,C,G,K]= obj.rotorsystem.assemble_system_matrices(omega*60/2/pi);
    
    A = sparse(n.entries,n.entries);
    B = sparse(n.entries,n.entries);
    
    ind1 = 1:n.entries/2;
    ind2 = n.entries/2+1:n.entries;
    % set matrix A
    A(ind1,ind1) = sparse(M);
    A(ind2,ind2) = sparse(K);
    % set matrix B
    B(ind1,ind1) = sparse(omega*G+C);
    B(ind1,ind2) = sparse(K);
    B(ind2,ind1) = sparse(-K);
end