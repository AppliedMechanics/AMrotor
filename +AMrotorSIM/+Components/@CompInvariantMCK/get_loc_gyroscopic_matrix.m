% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [G] = get_loc_gyroscopic_matrix(self,varargin)
% Provides/builds local gyroscopic matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Gyroscopic component matrix G
    
    G = self.gyroscopic_matrix;

end