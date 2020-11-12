function [D] = get_loc_damping_matrix(self,rpm)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Angular velocity
%    :type rpm: double
%    :return: Damping component matrix D

% Licensed under GPL-3.0-or-later, check attached LICENSE file

Table = self.cnfg.Table;
[ D ] = self.LookUpTable( Table.rpm, Table.damping_matrix, rpm );    

self.damping_matrix = D;
end