function [M_A] = compute_axial_mass_matrix(Element)
    E = Element;
    M_A =zeros(2,2);
    M_A(1,1) = (1/6)*E.material.density*E.area*E.length*2;
    M_A(2,2) = M_A(1,1);
    M_A(1,2) = (1/6)*E.material.density*E.area*E.length*1;
    M_A(2,1) = M_A(1,2);
end