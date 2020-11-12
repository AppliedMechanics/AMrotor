function [K] = get_loc_stiffness_matrix(self,varargin)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Stiffness component matrix K

% Licensed under GPL-3.0-or-later, check attached LICENSE file
            
    K=self.stiffness_matrix;    
end