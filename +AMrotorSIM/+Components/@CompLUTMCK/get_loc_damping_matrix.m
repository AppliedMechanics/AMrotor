function [D] = get_loc_damping_matrix(self,rpm)

[ ~ ,D, ~ ] = self.LookUpTable( rpm );
% dof-order: ux,uy,uz,psix,psiy,psiz

self.damping_matrix = D;
end