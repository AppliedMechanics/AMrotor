function [K] = get_loc_stiffness_matrix(self,rpm)
            
    % dof-order: ux,uy,uz,psix,psiy,psiz
    [~,~,K] = get_loc_system_matrices(self,rpm);    
            
    self.stiffness_matrix = K;
end