function [K_F1, K_F2]=compute_bending_stiffness_matrix(Element)
       E = Element;
       phi = (12*E.material.e_module * E.I_y*E.material.shear_factor)/...
                (E.material.G_module*E.area*E.length^2); % ratio between the shear and the flexural flexibility of the beam
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
       K_F1(3,4) = var*-6*E.length^2;
       
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