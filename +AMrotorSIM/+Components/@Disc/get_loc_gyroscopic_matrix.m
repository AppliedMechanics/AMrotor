function [G] = get_loc_gyroscopic_matrix(self,varargin)
    
    G = sparse(6,6);
    G(4,5)=+self.cnfg.Jp;
    G(5,4)=-self.cnfg.Jp;

    % dof-order: ux,uy,uz,psix,psiy,psiz
 
    self.gyroscopic_matrix = G;

end