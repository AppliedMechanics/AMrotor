function [K] = get_loc_stiffness_matrix(self,rpm)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Angular velocity
%    :type rpm: double
%    :return: Component stiffness matrix K

% Licensed under GPL-3.0-or-later, check attached LICENSE file

Table = self.cnfg.Table;
[ K ] = self.LookUpTable( Table.rpm, Table.stiffness_matrix, rpm ); 

self.stiffness_matrix = K;
end