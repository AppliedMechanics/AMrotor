function [G_ele] = compute_gyroscopic_matrix(Element)
    E = Element;
    k_sc = (6*(1+E.material.poisson))/(7+6*E.material.poisson);
    phi = (12*E.material.e_module * E.I_y*E.material.shear_factor)/...
                (k_sc*E.material.G_module*E.area*E.length^2);
            
    a = (E.material.density*E.area*E.radius^2)/(60*(1+phi)^2*E.length);
    
    %G = G0+phi*G1+phi^2*G2

    G0 = sparse(8,8);
    G1 = sparse(8,8);
    G2 = sparse(8,8);

    % Einträge G0 
    G0(3,1)= 36;
    G0(1,3) = -G0(1,2);
    
    G0(2,1) = -3*E.length;
    G0(1,2) = -G0(3,1);
    
    G0(7,1) = -36;
    G0(1,7) = -G0(6,1);
    
    G0(6,1) = -3*E.length;
    G0(1,6) = -G0(7,1);
    
    G0(4,3) = -3*E.length;
    G0(3,4) = -G0(4,2);
    
    G0(5,3) = 36;
    G0(3,5) = -G0(5,2);
    
    G0(8,3) = -3*E.length;
    G0(3,8) = -G0(8,2);
    
    G0(4,2) = 4*E.length^2;
    G0(2,4) = -G0(4,3);
    
    G0(5,2) = -3*E.length;
    G0(2,5) = -G0(5,3);
    
    G0(8,2) = -E.length^2;
    G0(2,8) = -G0(8,3);
    
    G0(7,4) = -3*E.length;
    G0(4,7) = -G0(6,4);
    
    G0(6,4) = E.length^2;
    G0(4,6) = -G0(7,4);
    
    G0(7,5) = 36;
    G0(5,7) = -G0(6,5);
    
    G0(6,5) = 3*E.length;
    G0(5,6) = -G0(7,5);
    
    G0(8,7) = 3*E.length;
    G0(7,8) = -G0(8,6);
    
    G0(8,6) = 4*E.length^2;
    G0(6,8) = -G0(8,7);
    
    G0 = a*G0;
    
    %Einträge G1
    
    G1(2,1) = 15*E.length;
    G1(1,2) = -G1(3,1);
    
    G1(6,1) = 15*E.length;
    G1(1,6) = -G1(7,1);
    
    G1(4,3) = 15*E.length;
    G1(3,4) = -G1(4,2);
    
    G1(8,3) = 15*E.length;
    G1(3,8) = -G1(8,2);
    
    G1(4,2) = 5*E.length^2;
    G1(2,4) = -G1(4,3);
    
    G1(5,2) = 15*E.length;
    G1(2,5) = -G1(5,3);
    
    G1(8,2) = -5*E.length^2;
    G1(2,8) = -G1(8,3);
    
    G1(7,4) = 15*E.length;
    G1(4,7) = -G1(6,4);
    
    G1(6,4) = 5*E.length^2;
    G1(4,6) = -G1(7,4);
    
    G1(8,5) = -15*E.length;
    G1(5,8) = -G1(8,5);
    
    G1(8,7) = 5*E.length^2;
    G1(7,8) = -G1(8,6);
    
    G1(8,6) = 5*E.length^2;
    G1(6,8) = -G1(8,7);
    
    G1 = a*G1;
    
    %Einträge G3
    
    G2(4,2) = 10*E.length^2;
    G2(2,4) = -G2(4,3);
    
    G2(8,2) = 5*E.length^2;
    G2(2,8) = -G2(8,3);
    
    G2(6,4) = -5*E.length^2;
    G2(4,6) = -G2(7,4);
    
    G2(8,6) = 10*E.length^2;
    G2(6,8) = -G2(8,7);
    
    G2 = a*G2;
    
    %Gyroscopic Matrix for Element
    G_ele = G0+phi*G1+phi^2*G2;
end