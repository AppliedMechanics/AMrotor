function K_A = compute_axial_stiffness_matrix(Element)
    E = Element;
    K_A = zeros(2,2);
    K_A(1,1) = (E.material.e_module*E.area)/E.length*1;
    K_A(1,2) =(E.material.e_module*E.area)/E.length*-1;
    K_A(2,2) = K_A(1,1);
    K_A(2,1) = K_A(1,2);
    
end