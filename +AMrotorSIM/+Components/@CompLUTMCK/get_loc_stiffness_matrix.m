function [K] = get_loc_stiffness_matrix(self,rpm)

[ ~, ~, K ] = self.LookUpTable( rpm );
% dof-order: ux,uy,uz,psix,psiy,psiz


self.stiffness_matrix = K;
end