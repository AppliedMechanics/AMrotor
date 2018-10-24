function [M] = get_loc_mass_matrix(self,rpm_current)

    M = sparse(6,6);
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    self.mass_matrix = M;
end