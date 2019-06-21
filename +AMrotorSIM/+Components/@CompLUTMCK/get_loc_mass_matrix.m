function [M] = get_loc_mass_matrix(self,rpm)

[ M, ~, ~ ] = self.LookUpTable( rpm );
% dof-order: ux,uy,uz,psix,psiy,psiz

self.mass_matrix = M;
end