function [M_T] = compute_tangential_mass_matrix(Element)
    E = Element;
    M_T = zeros(2,2);
    M_T(1,1) = (E.material.density*E.I_p*E.length)/6*2;
    M_T(1,2) =(E.material.density*E.I_p*E.length)/6*1;
    M_T(2,2) = M_T(1,1);
    M_T(2,1) = M_T(1,2);
end