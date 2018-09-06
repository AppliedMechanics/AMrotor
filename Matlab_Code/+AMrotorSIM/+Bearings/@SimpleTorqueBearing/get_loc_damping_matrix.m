function [G] = get_loc_damping_matrix(self)
    
     G = sparse(6,6);
    % dof-order: ux,uy,uz,psix,psiy,psiz
 
    self.damping_matrix = G;
end