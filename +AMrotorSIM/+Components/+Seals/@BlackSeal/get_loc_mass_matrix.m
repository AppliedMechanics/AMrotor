% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [M] = get_loc_mass_matrix(self,rpm)
% Provides/builds local mass matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Angular velocity
%    :type rpm: double
%    :return: Mass component matrix M

    [M,~,~] = get_loc_system_matrices(self,rpm);
    
    self.mass_matrix = M;
end