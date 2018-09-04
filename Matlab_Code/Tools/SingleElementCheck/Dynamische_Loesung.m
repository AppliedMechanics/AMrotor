% Aufräumen
clear all
close all
clc

%% Element FEM Lösung

load Matrizen.mat
nModes=12;

 [V,D_tmp] = eigs(-K,M,nModes,'sm');
 [D,order] = sort(imag(sqrt(diag(D_tmp))));
    % sorting
    for i = 1:length(order)
        tmp = V(:,i);
        V(:,i) = V(:,order(i));
        V(:,order(i)) = tmp;
    end

f=D./(2*pi);
f_1=f(5); 

%% Analytische Eigenmoden
% Geometrie und Materialparameter -----------------------------------------

e_module = 211e9;  %[N/m^2]
density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
poisson  = 0.3;    %steel 0.27...0.3 [-]
shear_factor = 0.9;

length = 0.5;       %[m]
diameter = 0.005;   %[m]

Area=0.25*diameter^2*pi;
I=Area/4*1/4*diameter^2;

lambda=22.4;    %frei-frei

% Eigenfrequenzen ---------------------------------------------------------

omega_1=lambda*sqrt(e_module*I/(density*Area*length^4));
f_1a=omega_1/2/pi;