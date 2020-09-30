% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [D] = get_loc_damping_matrix(self,varargin)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Damping component matrix D

D = sparse(6,6);

self.damping_matrix = D;
end