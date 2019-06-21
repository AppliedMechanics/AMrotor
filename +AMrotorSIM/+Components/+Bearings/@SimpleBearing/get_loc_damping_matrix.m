function [D] = get_loc_damping_matrix(self,varargin)
    
     D = sparse(6,6);
    % dof-order: ux,uy,uz,psix,psiy,psiz
    D(1,1)=self.cnfg.damping;
    D(2,2)=self.cnfg.damping;
 
    self.damping_matrix = D;
end