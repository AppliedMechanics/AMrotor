function [M] = get_loc_mass_matrix(self,varargin)
% Provides/builds local mass matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Mass component matrix M

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    M = sparse(6,6);
    
    self.mass_matrix = M;
end