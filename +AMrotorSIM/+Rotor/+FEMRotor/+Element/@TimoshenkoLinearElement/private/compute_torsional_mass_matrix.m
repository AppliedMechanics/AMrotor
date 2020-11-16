function [M_T] = compute_torsional_mass_matrix(Element)
% Builds the torsional mass submatrix 
%
%    :return: Torsional mass submatrix M_T

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    E = Element;
    M_T = zeros(2,2);
    M_T(1,1) = (E.material.density*E.I_p*E.length)/6*2;
    M_T(1,2) =(E.material.density*E.I_p*E.length)/6*1;
    M_T(2,2) = M_T(1,1);
    M_T(2,1) = M_T(1,2);
end