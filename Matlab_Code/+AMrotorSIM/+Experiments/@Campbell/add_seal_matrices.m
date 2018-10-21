function [M,D,K] = add_seal_matrices(obj,rpm)
%ADD_SEAL_MATRICES Adds the seal matrices to the global sytsemmatrices
%   [M_out,D_out,K_out] = add_seal_matrices(obj,rpm)
%   Adds the seal matrices to the input systemmatrices in
%   obj.rotorsystem.systemmatrices calls the new systemmatrices M_out,
%   D_out, K_out. Seal matrices are dependent on the rotational speed rpm
%   (in 1/min). 

M = obj.rotorsystem.systemmatrices.M;
D = obj.rotorsystem.systemmatrices.D;
K = obj.rotorsystem.systemmatrices.K;
% G = obj.rotorsystem.systemmatrices.G;

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
   end
   
    M = M + M_seal;
    D = D + D_seal;
    K = K + K_seal; 
end

