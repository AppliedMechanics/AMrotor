function [K_T] = compute_torsional_stiffness_matrix(Element)
    E = Element;
    G = 1/(2*(1+E.material.poisson)); %Schubmodul
    
    K_T = zeros(2,2);
    
    K_T(1,1) = (G*E.I_p)/E.length*1;
    K_T(1,2) = (G*E.I_p)/E.length*-1;
    K_T(2,1) = K_T(1,2);
    K_T(2,2) = K_T(1,1);
    
    
end