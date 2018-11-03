function [G] = get_loc_gyroscopic_matrix(self,varargin)
    
     G = sparse(6,6);
    % dof-order: ux,uy,uz,psix,psiy,psiz
 
    self.gyroscopic_matrix = G;
end