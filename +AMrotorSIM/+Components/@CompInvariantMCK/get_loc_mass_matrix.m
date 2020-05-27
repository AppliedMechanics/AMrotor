function [M] = get_loc_mass_matrix(self,varargin)

    M = self.mass_matrix;

    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    self.mass_matrix = M;
end