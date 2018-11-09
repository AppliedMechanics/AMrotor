function [M_s,D_s,K_s] = get_loc_system_matrices(self,rpm)
% dof-order: ux,uy,uz,psix,psiy,psiz

M = sparse(6,6);
D = sparse(6,6);
K = sparse(6,6);

[ M_s,D_s,K_s ] = self.LookUpTable( rpm );

M(1:2,1:2) = M_s;
D(1:2,1:2) = D_s;
K(1:2,1:2) = K_s;

self.mass_matrix = M;
self.damping_matrix = D;
self.stiffness_matrix = K;

end