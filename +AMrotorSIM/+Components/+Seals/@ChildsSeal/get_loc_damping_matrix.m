function [D] = get_loc_damping_matrix(self,rpm)
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    [~,D,~] = get_loc_system_matrices(self,rpm);
 
    self.damping_matrix = D;
end