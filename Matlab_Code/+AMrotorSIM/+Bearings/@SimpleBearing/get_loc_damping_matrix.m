function [D] = get_loc_damping_matrix(self,varargin)
    
     D = sparse(6,6);
    % dof-order: ux,uy,uz,psix,psiy,psiz
 
    self.damping_matrix = D;
end