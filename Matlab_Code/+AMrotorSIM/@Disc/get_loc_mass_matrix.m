function [M] = get_loc_mass_matrix(self)

    M = sparse(6,6);
    M(1,1)=self.cnfg.m;
    M(2,2)=self.cnfg.m;
    M(3,3)=self.cnfg.m;
    M(4,4)=self.cnfg.Jx;
    M(5,5)=self.cnfg.Jx;
    M(6,6)=self.cnfg.Jz;

    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    self.mass_matrix = M;
end