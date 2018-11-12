function [A,B] = get_state_space_matrices_variant(obj,omega)

[M,C,G,K]= obj.rotorsystem.assemble_system_matrices(omega*60/2/pi);
M_inv = M\eye(size(M));



A = sparse([zeros(length(M)), eye(length(M)); -M_inv*K, -M_inv*C-M_inv*G*omega]);
B= sparse([zeros(length(M)),zeros(length(M));zeros(length(M)),M_inv]);

end