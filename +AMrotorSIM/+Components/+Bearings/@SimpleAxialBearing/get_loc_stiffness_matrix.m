function [K] = get_loc_stiffness_matrix(self,varargin)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Stiffness component matrix K

% Licensed under GPL-3.0-or-later, check attached LICENSE file
            
    K=sparse(6,6);
    
    K(3,3)=self.cnfg.stiffness;
    
            
    self.stiffness_matrix = K;
end