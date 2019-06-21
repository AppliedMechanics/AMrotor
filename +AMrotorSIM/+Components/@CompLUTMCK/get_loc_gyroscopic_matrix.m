function [G] = get_loc_gyroscopic_matrix(self,varargin)
if isfield(self.cnfg.Table,'gyroscopic_matrix')
    Table = self.cnfg.Table;
    [ G ] = self.LookUpTable( Table.rpm, Table.gyroscopic_matrix, rpm );
else
    G = sparse(6,6);
end
% dof-order: ux,uy,uz,psix,psiy,psiz

self.gyroscopic_matrix = G;
end