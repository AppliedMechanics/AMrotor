function [M] = get_loc_mass_matrix(self,rpm)
Table = self.cnfg.Table;
[ M ] = self.LookUpTable( Table.rpm, Table.mass_matrix, rpm );    
% dof-order: ux,uy,uz,psix,psiy,psiz

self.mass_matrix = M;
end