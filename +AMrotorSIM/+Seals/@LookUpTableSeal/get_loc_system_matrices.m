function [M_s,D_s,K_s] = get_loc_system_matrices(self,rpm)
% dof-order: ux,uy,uz,psix,psiy,psiz

[ M_s,D_s,K_s ] = self.LookUpTable( rpm );


self.mass_matrix = M_s';
self.damping_matrix = D_s';
self.stiffness_matrix = K_s';

end