function [g1, g2] = compute_gyroscopic_matrix(Element)
% Builds the gyroscopic submatrix 
%
%    :return: Gyroscopic submatrix G_1 and G_2

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    % Aus compute_flexural_mass kopiert:
    % Test, ob Implementierung nach genta S. 163 einen Vorteil bringt.
        E = Element;
    
    r_bar = E.radius_inner/E.radius_outer;
    k_sc = (6*(1+E.material.poisson)*(1+r_bar)^2)/((7+6*E.material.poisson)*(1+r_bar)^2+(20+12*E.material.poisson)*r_bar^2); %Tiwari p.608
    phi = (12*E.material.e_module * E.I_y)/... % in rt_chapter10 auf S. 620 steht: Phi = 12*E*I_xx/(k_sc*G*A*l^2), also ohne shear-factor; in Genta S. 372 steht 12*E*I_xx*xi/(G*A*l^2), ohne k_sc aber mit xi,welches evtl. shear_factor ist
                (k_sc*E.material.G_module*E.area*E.length^2); % ratio between the shear and the flexural flexibility of the beam
    
    m1 = 156+294*phi+140*phi^2;
    m2 = 22+38.5*phi+17.5*phi^2;
    m3 = 54+126*phi+70*phi^2;
    m4 = 13+31.5*phi+17.5*phi^2;
    m5 = 4+7*phi+3.5*phi^2;
    m6 = 3+7*phi+3.5*phi^2;
    m7 = 36;
    m8 = 3-15*phi;
    m9 = 4+5*phi+10*phi^2;
    m10 = 1+5*phi-5*phi^2;%ausgebessert siehe Genta S.163
    
    b = (E.material.density*E.I_y)/(30*E.length*(1+phi)^2);
    
    %%x-z Plane
    M_R1 = zeros (4,4);
        
    M_R1(1,1) = b*m7;
    M_R1(1,2) = b*E.length*m8;
    M_R1(1,3) = b*-m7;
    M_R1(1,4) = b*E.length*m8;
    
    M_R1(2,1) = M_R1(1,2);
    M_R1(2,2) = b*E.length^2*m9;
    M_R1(2,3) = b*E.length*(-m8);
    M_R1(2,4) = b*E.length^2*(-m10);
    
    M_R1(3,1) = M_R1(1,3);
    M_R1(3,2) = M_R1(2,3);
    M_R1(3,3) = b*m7;
    M_R1(3,4) = b*E.length*(-m8);
    
    M_R1(4,1) = M_R1(1,4);
    M_R1(4,2) = M_R1(2,4);
    M_R1(4,3) = M_R1(3,4);
    M_R1(4,4) = b*E.length^2*m9;
   
    
    
    g = 2*M_R1; %siehe Notizen vom 10.02.2022
    
    g1 = g * diag([1, -1, 1, -1]);
    g2 = diag([-1, 1, -1, 1]) * g;
    
    
end