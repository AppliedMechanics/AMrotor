% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [K] = get_loc_stiffness_matrix(self,rpm)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param rpm: Rotation speed
%    :type rpm: double
%    :return: Stiffness component matrix K

    [~,~,K] = get_loc_system_matrices(self,rpm);    
            
    self.stiffness_matrix = K;
end