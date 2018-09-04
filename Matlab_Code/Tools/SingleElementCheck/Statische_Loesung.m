%% Skript um ein einzelnes Element zu checken.
% Aufräumen
clear all 
close all
clc

%% Element FEM Lösung
load Matrizen.mat

K_fest = K(7:12,7:12); % Linkes Ende einspannen.
M_fest = M(7:12,7:12);

% Dehung in z-Richtung ----------------------------------------------------
f=sparse(6,1);
f(3)=1; %[N] Kraft

u=K_fest\f;

u_z = u(3); %[m] Verschiebung

% Torsion um z-Achse ------------------------------------------------------
f=sparse(6,1);
f(6)=1; %[Nm]

u=K_fest\f;

psi_z = u(6);

% Biegung in x-Richtung ---------------------------------------------------
f=sparse(6,1);
f(1)=1; %[N] Kraft

u=K_fest\f;

u_x = u(1); %[m] Verschiebung

% Biegung in x-Richtung ---------------------------------------------------
f=sparse(6,1);
f(2)=1; %[N] Kraft

u=K_fest\f;

u_y = u(2); %[m] Verschiebung

%% Analytischen Lösungen

% Geometrie und Materialparameter -----------------------------------------

e_module = 211e9;  %[N/m^2]
density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
poisson  = 0.3;    %steel 0.27...0.3 [-]
shear_factor = 0.9;
G_module=e_module/(2*(1+poisson)); %[N/m^2] - Wikipedia: 79,3e9 für Stahl

length = 0.5;       %[m]
diameter = 0.005;   %[m]


area=0.25*diameter^2*pi;
I=area/4*1/4*diameter^2;
I_polar=2*I;

% Dehnstab ----------------------------------------------------------------
Force = 1; %[N]
u_za=length*Force/(e_module*area);

% Torsionsstab ------------------------------------------------------------
Torque = 1; %[Nm]
psi_za = Torque*length/(G_module*I_polar);

% Biegebalken -------------------------------------------------------------
Force = 1; %[N]
u_xab=Force*length^3/(3*e_module*I); %Euler-Bernoulli-Balken
u_yab=Force*length^3/(3*e_module*I);

u_xat=Force*length^3/(3*e_module*I)+Force*length/(G_module+shear_factor*area); %Timoshenko-Balken
