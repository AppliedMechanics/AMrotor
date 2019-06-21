function [M] = get_loc_mass_matrix(self,rpm)

    % dof-order: ux,uy,uz,psix,psiy,psiz
    [M,~,~] = get_loc_system_matrices(self,rpm);
    
    self.mass_matrix = M;
end