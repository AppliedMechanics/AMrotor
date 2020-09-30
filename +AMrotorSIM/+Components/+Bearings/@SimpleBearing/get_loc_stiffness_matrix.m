% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [K] = get_loc_stiffness_matrix(self,varargin)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Stiffness component matrix K
            
    K=sparse(6,6);
    
    K(1,1)=self.cnfg.stiffness;
    K(2,2)=self.cnfg.stiffness;
            
    self.stiffness_matrix = K;
end