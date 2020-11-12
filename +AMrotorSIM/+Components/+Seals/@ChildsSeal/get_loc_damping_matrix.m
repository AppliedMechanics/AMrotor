function [D] = get_loc_damping_matrix(self,rpm)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Rotation speed
%    :type rpm: double
%    :return: Component stiffness matrix D

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    [~,D,~] = get_loc_system_matrices(self,rpm);
 
    self.damping_matrix = D;
end