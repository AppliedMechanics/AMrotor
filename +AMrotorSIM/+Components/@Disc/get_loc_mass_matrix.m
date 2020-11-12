function [M] = get_loc_mass_matrix(self,varargin)
% Provides/builds local mass matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Mass component matrix M

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    M = sparse(6,6);
    M(1,1)=self.cnfg.m;
    M(2,2)=self.cnfg.m;
    M(3,3)=self.cnfg.m;
    M(4,4)=self.cnfg.Jx;
    M(5,5)=self.cnfg.Jx;
    M(6,6)=self.cnfg.Jz;
    
    self.mass_matrix = M;
end