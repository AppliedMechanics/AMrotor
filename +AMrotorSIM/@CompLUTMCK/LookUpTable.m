function [ M_seal, D_seal ,K_seal ] = LookUpTable( self, rpm_current )     

Table = self.cnfg.Table;
K_seal = zeros(6,6);
for i = 1:6
    for j = 1:6
        if isempty(Table.stiffness_matrix{i,j}) %allows slim tables, only interesting coefficiens are stored
            K_seal(i,j)=0;
        else
            K_seal(i,j) = interp1(Table.rpm, Table.stiffness_matrix{i,j}, rpm_current, 'linear');
        end
    end
end
K_seal = sparse(K_seal);
% dof-order: ux,uy,uz,psix,psiy,psiz

D_seal = zeros(6,6);
for i = 1:6
    for j = 1:6
        if isempty(Table.damping_matrix{i,j})
            D_seal(i,j)=0;
        else
            D_seal(i,j) = interp1(Table.rpm, Table.damping_matrix{i,j}, rpm_current, 'linear');
        end
    end
end
D_seal = sparse(D_seal);
% dof-order: ux,uy,uz,psix,psiy,psiz

M_seal = zeros(6,6);
for i = 1:6
    for j = 1:6
        if isempty(Table.mass_matrix{i,j})
            M_seal(i,j)=0;
        else
            M_seal(i,j) = interp1(Table.rpm, Table.mass_matrix{i,j}, rpm_current, 'linear');
        end
    end
end
M_seal = sparse(M_seal);
% dof-order: ux,uy,uz,psix,psiy,psiz

self.stiffness_matrix = K_seal;
self.damping_matrix = D_seal;
self.damping_matrix = M_seal; 

if rpm_current > max(Table.rpm)
    warning(['Extrapolation of Component-Coefficients from Look-Up-Table ',... 
            'at rotational speed of more than max(Table.rpm)=',...
            num2str(max(Table.rpm)),'. ',...
            'Results may be inaccurate!']);
end
end

