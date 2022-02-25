function [g_AB, g_BA] = compute_gyroscopic_matrix(Element)
% Builds the gyroscopic submatrix
%
%    :return: Gyroscopic submatrix g_AB and g_BA

% Licensed under GPL-3.0-or-later, check attached LICENSE file

% gyroscopic matrix implemented according to Chapter 4 in
% Genta, G. (2005). Dynamics of Rotating Systems.
% Springer US. https://doi.org/10.1007/0-387-28687-X

E = Element;

%% copied from compute_flexural_mass
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
m10 = 1+5*phi-5*phi^2;

b = (E.material.density*E.I_y)/(30*E.length*(1+phi)^2);

%% x-z Plane, rotational mass
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

%% building gyroscopic matrices from mass
% From Genta
% q_Genta = [u_x1+i*u_y1; psi_y1-i*psi_x1; u_x2+i*u_y2; psi_y2-i*psi_x2]
%
%
% here:
% q_A = [u_x1; psi_y1; u_x2; psi_y2] (bending in x-z-plane)
% q_B = [u_y1; psi_x1; u_y2; psi_x2] (bending in y-z-plane)



g = 2*M_R1; % for Genta-dofs

% transform to be used with q_A and q_B
% f_A_gyros = gAB * q_B
% f_B_gyros = gBA * q_A
g_AB = g * diag([1, -1, 1, -1]);
g_BA = diag([-1, 1, -1, 1]) * g;


end