function [D] = get_loc_damping_matrix(self,rpm)
Table = self.cnfg.Table;
[ D ] = self.LookUpTable( Table.rpm, Table.damping_matrix, rpm );    
% dof-order: ux,uy,uz,psix,psiy,psiz

self.damping_matrix = D;
end