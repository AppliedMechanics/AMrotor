% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [G] = get_loc_gyroscopic_matrix(self,varargin)
% Provides/builds local gyroscopic matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Gyroscopic component matrix G

if isfield(self.cnfg.Table,'gyroscopic_matrix')
    Table = self.cnfg.Table;
    [ G ] = self.LookUpTable( Table.rpm, Table.gyroscopic_matrix, rpm );
else
    G = sparse(6,6);
end

self.gyroscopic_matrix = G;
end