function [A,B] = getStateSpaceMatrices(obj,omega)
    n.nodes = length(obj.rotorSystem.rotor.nodes);
    n.entries = n.nodes*4*2; % 4 because of 4 dof per node and 2 because
                             % matrices will be stated as state space
                             % system
    A = sparse(n.entries,n.entries);
    B = sparse(n.entries,n.entries);
    
    ind1 = 1:n.entries/2;
    ind2 = n.entries/2+1:n.entries;
    % set matrix A
    A(ind1,ind1) = sparse(obj.rotorSystem.systemmatrizen.M);
    A(ind2,ind2) = sparse(obj.rotorSystem.systemmatrizen.K);
    % set matrix B
    B(ind1,ind1) = sparse(omega*obj.rotorSystem.systemmatrizen.G);
    B(ind1,ind2) = sparse(obj.rotorSystem.systemmatrizen.K);
    B(ind2,ind1) = sparse(-obj.rotorSystem.systemmatrizen.K);
end