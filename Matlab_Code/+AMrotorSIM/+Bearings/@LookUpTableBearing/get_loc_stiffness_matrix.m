function [K] = get_loc_stiffness_matrix(self,varargin)
% Initialize matrix with values at rpm=0 
% Matrix is dependent on the rotational speed -> calculation for every
% rpm-step required, similar to Seal-matrices
    rpm_current = varargin{1};
    Table = self.cnfg.Table;
    K = zeros(6,6);
    for i = [1,2,4,5]
        for j = [1,2,4,5] % keine Vorgabe der Steifigkeit in z-Richtung
            K(i,j) = interp1(Table.rpm, Table.stiffness_matrix{i,j}, rpm_current, 'spline');
        end
    end
    K = sparse(K);
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
            
    self.stiffness_matrix = K;
    
    if rpm_current > max(Table.rpm)
        warning(['Extrapolation of Bearing-Coefficients from Look-Up-Table ',... 
            'at rotational speed of more than max(Table.rpm). ',...
            'Results may be inaccurate!']);
    end
end