function [M] = get_loc_mass_matrix(self,rpm)
% Provides/builds local mass matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Angular velocity
%    :type rpm: double
%    :return: Mass component matrix M

% Rotational speed dependent mass matrix for example for seals.
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

Table = self.cnfg.Table;
[ M ] = self.LookUpTable( Table.rpm, Table.mass_matrix, rpm );    

self.mass_matrix = M;
end