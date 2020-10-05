% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [M_F1, M_F2] = compute_flexural_mass_matrix(Element)
% Builds bending mass submatrices
%
%    :return: Bending mass submatrices M_F1, M_F2

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
    
    a = (E.material.density*E.area*E.length)/(420*(1+phi)^2);
    b = (E.material.density*E.I_y)/(30*E.length*(1+phi)^2);
    
    %%x-z Plane
    M_F1 = zeros (4,4);
        
    M_F1(1,1) = a*m1+b*m7;
    M_F1(1,2) = a*E.length*m2+b*E.length*m8;
    M_F1(1,3) = a*m3+b*-m7;
    M_F1(1,4) = a*-m4*E.length + b*E.length*m8;
    
    M_F1(2,1) = M_F1(1,2);
    M_F1(2,2) = a*E.length^2*m5+b*E.length^2*m9;
    M_F1(2,3) = a*E.length*m4 + b*E.length*-m8;
    M_F1(2,4) = a*E.length^2*-m6+b*E.length^2*-m10;
    
    M_F1(3,1) = M_F1(1,3);
    M_F1(3,2) = M_F1(2,3);
    M_F1(3,3) = a*m1+b*m7;
    M_F1(3,4) = a*E.length*-m2+b*E.length*-m8;%ausgebessert siehe Genta S.163
    
    M_F1(4,1) = M_F1(1,4);
    M_F1(4,2) = M_F1(2,4);
    M_F1(4,3) = M_F1(3,4);
    M_F1(4,4) = a*E.length^2*m5 + b*E.length^2*m9;
   
    % y-z plane
    M_F2 = zeros(4,4);
    
    M_F2(1,1) = M_F1(1,1);
    M_F2(1,2) = -M_F1(1,2);
    M_F2(1,3) = M_F1(1,3);
    M_F2(1,4) = -M_F1(1,4);
    
    M_F2(2,1) = M_F2(1,2);
    M_F2(2,2) = M_F1(2,2);
    M_F2(2,3) = -M_F1(2,3);
    M_F2(2,4) = M_F1(2,4);
    
    M_F2(3,1) = M_F2(1,3);
    M_F2(3,2) = M_F2(2,3);
    M_F2(3,3) = M_F1(3,3);
    M_F2(3,4) = -M_F1(3,4);
    
    M_F2(4,1) = M_F2(1,4);
    M_F2(4,2) = M_F2(2,4);
    M_F2(4,3) = M_F2(3,4);
    M_F2(4,4) = M_F1(4,4);
end