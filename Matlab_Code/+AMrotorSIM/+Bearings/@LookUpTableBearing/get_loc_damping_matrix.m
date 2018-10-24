function [D] = get_loc_damping_matrix(self,rpm_current)
% Initialize matrix with values at rpm=0 
% Matrix is dependent on the rotational speed -> calculation for every
% rpm-step required, similar to Seal-matrices
    
    Table = self.cnfg.Table;
    D = zeros(6,6);
    for i = [1,2,4,5]
        for j = [1,2,4,5] % keine Vorgabe der Steifigkeit in z-Richtung
            D(i,j) = interp1(Table.rpm, Table.damping_matrix{i,j}, rpm_current, 'spline');
        end
    end
    D = sparse(D);
    % dof-order: ux,uy,uz,psix,psiy,psiz
 
    self.damping_matrix = D;
end