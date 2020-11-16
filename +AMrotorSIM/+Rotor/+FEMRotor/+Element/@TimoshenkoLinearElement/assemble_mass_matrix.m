function [M] = assemble_mass_matrix(self)
% Assembles mass matrix 
%
%    :return: Mass matrix M

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    M_A = compute_axial_mass_matrix(self);
    M_T = compute_torsional_mass_matrix(self);
    [M_F1, M_F2] = compute_flexural_mass_matrix(self);

    M = zeros(12,12);

    M(1:2,1:2) = M_A;
    M(3:4,3:4) = M_T;
    M(5:8,5:8) = M_F1;
    M(9:12,9:12) = M_F2;

    self.mass_matrix = M;
end