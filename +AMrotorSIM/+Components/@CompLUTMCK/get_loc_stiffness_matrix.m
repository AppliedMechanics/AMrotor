function [K] = get_loc_stiffness_matrix(self,rpm)
Table = self.cnfg.Table;
[ K ] = self.LookUpTable( Table.rpm, Table.stiffness_matrix, rpm );    
% dof-order: ux,uy,uz,psix,psiy,psiz


self.stiffness_matrix = K;
end