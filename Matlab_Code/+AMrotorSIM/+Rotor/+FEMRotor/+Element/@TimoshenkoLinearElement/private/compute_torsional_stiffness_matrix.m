function [K_T] = compute_torsional_stiffness_matrix(Element)
    E = Element;
    
    K_T = zeros(2,2);
    
    K_T(1,1) = (E.material.G_module*E.I_p)/E.length*1;
    K_T(1,2) = (E.material.G_module*E.I_p)/E.length*-1;
    K_T(2,1) = K_T(1,2);
    K_T(2,2) = K_T(1,1);
    
    
end