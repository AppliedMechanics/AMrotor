function [G_ele] = compute_gyroscopic_matrix(Element)
% Abhaengigkeit von Drehzahl in transform_StateSpace_variant verwirklicht
    E = Element;
    r_bar = E.radius_inner/E.radius_outer;
%     k_sc = (6*(1+E.material.poisson))/(7+6*E.material.poisson);
    k_sc = (6*(1+E.material.poisson)*(1+r_bar)^2)/((7+6*E.material.poisson)*(1+r_bar)^2+(20+12*E.material.poisson)*r_bar^2);
    phi = (12*E.material.e_module * E.I_y*E.material.shear_factor)/... % in rt_chapter10 auf S. 620 steht: Phi = 12*E*I_xx/(k_sc*G*A*l^2), also ohne shear-factor
                (k_sc*E.material.G_module*E.area*E.length^2);
            
    a = (E.material.density*E.area*E.radius_outer^2)/(60*(1+phi)^2*E.length);
    
    %G = G0+phi*G1+phi^2*G2

    G0 = sparse(8,8);
    G1 = sparse(8,8);
    G2 = sparse(8,8);

    % Fehler in der Implementierung: G_ele ist mit der vorherigen
    % Implementierung nicht skew-symmetric, obwohl das gefordert ist. spy(G)
    % Meiner Meinung (MK) nach stimmt auch die dof-Reihenfolge nicht.
    
    % Eintraege G0 
    G0(5,1)= 36;
    G0(1,5) = -G0(5,1);
    G0(6,1)= -3*E.length;
    G0(1,6) = -G0(6,1);
    G0(7,1)= -36;
    G0(1,7) = -G0(7,1);
    G0(8,1)= -3*E.length;
    G0(1,8) = -G0(8,1);
    
    G0(2,5)= -3*E.length;
    G0(5,2) = -G0(2,5);
    G0(3,5)= 36;
    G0(5,3) = -G0(3,5);
    G0(4,5)= -3*E.length;
    G0(5,4) = -G0(4,5);
    
    G0(2,6)= 4*E.length^2;
    G0(6,2) = -G0(2,6);
    
    G0(3,6)= -3*E.length;
    G0(6,3) = -G0(3,6);
    G0(4,6)= -E.length^2;
    G0(6,4) = -G0(4,6);
    
    G0(7,2)= -3*E.length;
    G0(2,7) = -G0(7,2);
    G0(8,2)= E.length^2;
    G0(2,8) = -G0(8,2);
    
    G0(7,3)= 36;
    G0(3,7) = -G0(7,3);
    G0(8,3)= 3*E.length;
    G0(3,8) = -G0(8,3);
    
    G0(4,7)= 3*E.length;
    G0(7,4) = -G0(4,7);
    
    G0(4,8)= 4*E.length^2;
    G0(8,4) = -G0(4,8);
    
    G0 = a*G0;
    
    %Eintraege G1
    
    G1(6,1) = 15*E.length;
    G1(1,6) = -G1(6,1);
    G1(8,1) = 15*E.length;
    G1(1,8) = -G1(8,1);
    
    G1(2,5) = 15*E.length;
    G1(5,2) = -G1(2,5);   
    G1(4,5) = 15*E.length;
    G1(5,4) = -G1(4,5);
    
    G1(2,6) = 5*E.length^2;
    G1(6,2) = -G1(2,6);
    G1(3,6) = 15*E.length;
    G1(6,3) = -G1(3,6);
    G1(4,6) = -5*E.length^2;
    G1(6,4) = -G1(4,6);
    
    G1(7,2) = 15*E.length;
    G1(2,7) = -G1(7,2);
    G1(8,2) = 5*E.length^2;
    G1(2,8) = -G1(8,2);
    
    G1(4,3) = -15*E.length;
    G1(3,4) = -G1(4,3);
    
    G1(4,7) = 5*E.length^2;
    G1(7,4) = -G1(4,7);
    
    G1(4,8) = 5*E.length^2;
    G1(8,4) = -G1(4,8);
    
    G1 = a*G1;
    
    %Eintraege G2
    
    G2(6,2) = 10*E.length^2;
    G2(2,6) = -G2(6,2);
    
    G2(6,4) = 5*E.length^2;
    G2(4,6) = -G2(6,4);
    
    G2(8,2) = -5*E.length^2;
    G2(2,8) = -G2(8,2);
    
    G2(4,8) = 10*E.length^2;
    G2(8,4) = -G2(4,8);
    
    G2 = a*G2;
    
    %Gyroscopic Matrix for Element
    G_ele = G0+phi*G1+phi^2*G2;
end