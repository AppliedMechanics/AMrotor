 r=load('C:\Users\Christian Looschen\Documents\HiWi\AMrotor\Matlab_Code\Tools\Elementcheck\M_Matrix_1_Element.mat');
 
 K_new = r.r.rotor.stiffness_matrix (7:12,7:12);
 
 f = zeros(6,1);
 f(1,1) = 1;
 
 u_x = K_new\f;
 
 u_y = K_new\[0 1 0 0 0 0]';
 
 u_z = K_new\[0 0 1 0 0 0]';
 
 xi_x = K_new\[0 0 0 1 0 0]';
 
 xi_y = K_new\[0 0 0 0 1 0]';
 
 xi_z = K_new\[0 0 0 0 0 1]';
 
 %%Analytische Rechnung
 E = r.r.rotor.material.e_module;
 A = r.r.rotor.mesh.elements.area;
 l = r.r.rotor.mesh.elements.length;
 
 u_z_analy = 1*l/(E*A);
 
 U_x_analy = 1*l^3/(48*E*I_y)