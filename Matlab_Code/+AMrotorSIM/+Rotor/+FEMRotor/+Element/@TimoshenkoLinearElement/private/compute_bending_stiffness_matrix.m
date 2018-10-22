function [K_F1, K_F2]=compute_bending_stiffness_matrix(Element)
       E = Element;
       radius_outer = E.radius;
       radius_inner = 0;
       r_bar = radius_inner/radius_outer;
       k_sc = (6*(1+E.material.poisson)*(1+r_bar)^2)/((7+6*E.material.poisson)*(1+r_bar)^2+(20+12*E.material.poisson)*r_bar^2); %Tiwari p.608
       phi = (12*E.material.e_module * E.I_y)/... % in rt_chapter10 auf S. 620 steht: Phi = 12*E*I_xx/(k_sc*G*A*l^2), also ohne shear-factor; in Genta S. 372 steht 12*E*I_xx*xi/(G*A*l^2), ohne k_sc aber mit xi,welches evtl. shear_factor ist
                    (k_sc*E.material.G_module*E.area*E.length^2); % ratio between the shear and the flexural flexibility of the beam
       var = (E.material.e_module * E.I_y)/(E.length^3*(1+phi));
       
       %x-z plane
       K_F1 = zeros(4,4);
       
       K_F1(1,1) = var*12;
       K_F1(1,2) = var*E.length*6;
       K_F1(1,3) = var*-12;
       K_F1(1,4) = var*6*E.length;
       
       K_F1(2,1) = K_F1(1,2);
       K_F1(2,2) = var*(4+phi)*E.length^2;
       K_F1(2,3) = var*-6* E.length;
       K_F1(2,4) = var*(2-phi)*E.length^2;
       
       K_F1(3,1) = K_F1(1,3);
       K_F1(3,2) = K_F1(2,3);
       K_F1(3,3) = var*12;
       K_F1(3,4) = var*-6*E.length;
       
       K_F1(4,1) = K_F1(1,4);
       K_F1(4,2) = K_F1(2,4);
       K_F1(4,3) = K_F1(3,4);
       K_F1(4,4) = var*(4+phi)*E.length^2;
       
       %y-z plane
       K_F2 = zeros(4,4);
       
       K_F2(1,1) = K_F1(1,1);
       K_F2(1,2) = -K_F1(1,2);
       K_F2(1,3) = K_F1(1,3);
       K_F2(1,4) = -K_F1(1,4);
       
       K_F2(2,1) = K_F2(1,2);
       K_F2(2,2) = K_F1(2,2);
       K_F2(2,3) = -K_F1(2,3);
       K_F2(2,4) = K_F1(2,4);
       
       K_F2(3,1) = K_F2(1,3);
       K_F2(3,2) = K_F2(2,3);
       K_F2(3,3) = K_F1(3,3);
       K_F2(3,4) = -K_F1(3,4);
       
       K_F2(4,1) = K_F2(1,4);
       K_F2(4,2) = K_F2(2,4);
       K_F2(4,3) = K_F2(3,4);
       K_F2(4,4) = K_F1(4,4);
end