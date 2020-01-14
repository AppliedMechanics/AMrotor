function [D] = get_loc_damping_matrix(self,varargin)
    
     D = sparse(6,6);
     % dof-order: ux,uy,uz,psix,psiy,psiz
     for i = 1:6
         D(i,i)=self.cnfg.damping;
     end
    self.damping_matrix = D;
end