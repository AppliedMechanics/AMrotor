function [ M_seal,D_seal ,K_seal ] = LookUpTable( self, rpm_current )     

Table = self.cnfg.sealModel.Table;

md = interp1(Table.rpm, Table.m_xx, rpm_current, 'spine');
Cd = interp1(Table.rpm, Table.d_xx, rpm_current, 'spline');
cc = interp1(Table.rpm, Table.d_xy, rpm_current, 'spline');
Kd = interp1(Table.rpm, Table.k_xx, rpm_current, 'spline');
kc = interp1(Table.rpm, Table.k_xy, rpm_current, 'spline');


M_seal = [md, 0; 0, md];
D_seal = [Cd, cc; -cc, Cd];
K_seal = [Kd, kc; -kc, Kd];
end

