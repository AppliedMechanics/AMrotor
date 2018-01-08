clc
clear all
close all

addpath(strcat(fileparts(which(mfilename)),'\gesamt Funktionen'));
addpath(strcat(fileparts(which(mfilename)),'\Rotor trocken'));
addpath(strcat(fileparts(which(mfilename)),'\postprocessing'));
% %KoSy:
%        Z-Längsachse des Rotors
%        X-Z-Ebene
%        verschiebung in X1       X1
%        drehung um Y1            Beta_1
%        verschiebung in X2       X2
%        drehung um Y2            Beta_2
%                                  :
%                                 Xn
%        
%        Y-Z-Ebene

%        verschiebung in Y1       Y1
%        drehung um Z1            Alpha_1
%        verschiebung in Y2       Y3
%        drehung um Z2            Alpha_2
%                                   :
%                                 Yn
%                                 Alpha_n



     
%% ========================================================================
%Input rotordata

%% ========================================================================

rotorpar.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
rotorpar.rotor_dimensions = [0,18,0;20,18,0; 21,20,0; 42,20,0; 65,20,0; 66,25,0;  119,25,0; 120,25,0;140,25,0; 141,145,25;  145,145,25;  165,145,25; 166,25,0; 237,25,0; 238,25,0; 267,25,0; 268,145,25;293,145,25;294,25,0; 405,25,0;431,25,0; 434,25,0;   435,80,25; 450,80,25;469,80,25;470,80,25; 505,80,25;506,25,0; 622,25,0; 623,20,0; 641,20,0; 655,20,0; 656,18,0;722,18,0 ]*1e-3; %[m] %Angefangen bei 0, die Durchmessersprünge am ende des Abschnites eingeben

rotorpar.shear_factor   = 0.9;  %!!!!!!!!!wird Automatisch korregiert wenn Kreisring.
                                %!!!!!!!!!Schubkorrekrutfaktor für Kreisquerschnitt 0.9[-], Kreisring 0.5[-]

%% ========================================================================
%discretisation level and meshing

%% ========================================================================
modal_reduction = 0;    %do you want reduce the system set 1 = yes, 0 = no 

moden = 10;             %set number of eigenvalue's for modal reduction

dz=0.01;                %set elemet length for meshing

    

[nodes] = meshing(rotorpar, dz);  %function divide rotor in thin disks

n_nodes=length(nodes);

[n] = plot_rotor_geometry(nodes,rotorpar);

%% ========================================================================
%matireal properties

%% ========================================================================

rotorpar.E_module = 211e9;                            %[N/m^2]

rotorpar.density  = 7446;                             %[kg/m^3]

rotorpar.poisson  = 0.3;                             %steel 0.27...0.3 [-]

%% ========================================================================
%bearing positions and Stiffnes

%% ========================================================================


rotorpar.bearing_pos1   = 65e-3;                        %[m]

rotorpar.bearing_pos2   = 655e-3;                        %[m]



rotorpar.bearing_stiff = 1e8;%7.0e5;              %[N/m]

rotorpar.bearing_stiff_ang = 0;





%% ========================================================================
%add disc

disc=1; % 1== Scheibe als Punktmasse, 0==Scheibe durch durchmessersprung 
%% ========================================================================
% 
z1 = 141e-3;                         %disc position [m]
% dz1= 30e-3;
% rz1= 50e-3;
% % % 
m1 = 2.97*0;                             %disc mass [kg]
% % % 
Ix1 = 1.0e-4*0;                         %disc mom. of inertia [m^4]
% % % 
Iz1 = 1.0e-4*0;                         %disc mom. of inertia [m^4]
% % %__________________________________________________________________________

 z2 = 268e-3;                          %disc position
% 
 m2 = 2.97*0;                            %disc mass
%  
Ix2 = 1.0e-4*0;                       %disc mom. of inertia
%  
Iz2 = 1.0e-4*0;                       %disc mom. of inertia
%__________________________________________________________________________

z3 = 405e-3;                            %disc position
% 
m3 = 0.6;                             %disc mass
% 
Ix3 = 1.54e-4*0;                        %disc mom. of inertia
% 
Iz3 = 1.54e-4*0;                        %disc mom. of inertia








%% ========================================================================
%Matrices of the system

%% ========================================================================

%%Rotorsystem%%
[moment_of_inertia] = compute_moment_of_inertia(rotorpar); %column_1 cross section area
                                                           %column_2 I_xi
                                                           %column_3 I_eta
                                                           %column_4 I_p
                                                           %column_5 PhiS
%massmatrix
M  = compute_mass_matrix(rotorpar,moment_of_inertia,nodes);

%add disc to the massmatrix

% 
% M = M_add_disc(M,nodes,z1, m1,Ix1,Iz1);
% 
% M = M_add_disc(M,nodes,z2, m2,Ix2,Iz2);
% 
M = M_add_disc(M,nodes,z3, m3,Ix3,Iz3);
% % 
% z=[425,515]*1e-3;
% 
% dn=(z(2)-z(1))/10;
% 
% k1=find(abs(nodes-z(1))<1e-4);
% k2=find(abs(nodes-z(2))<1e-4);
% dm=m3/(k2-k1);
% 
% for n=1:(k2-k1)
% 
%  
%     
% M = M_add_disc(M,nodes,nodes(k1+(n-1)), dm,Ix3,Iz3);
%  
% 
% end
%stiffnesmatrix
K  = compute_stiffnes_smatrix(rotorpar, moment_of_inertia, nodes);

%computing bearingstiffnes (as a spring)
Kb = bearing_stiffnes(rotorpar,nodes, [rotorpar.bearing_stiff,rotorpar.bearing_stiff,rotorpar.bearing_pos1;
                                       rotorpar.bearing_stiff,rotorpar.bearing_stiff,rotorpar.bearing_pos2
                                       
                                       ],moment_of_inertia);

                                   
                                

                                   
Tb = compute_bearing_torque([rotorpar.bearing_stiff_ang,rotorpar.bearing_pos1;
                             rotorpar.bearing_stiff_ang,rotorpar.bearing_pos2],nodes);                                   
                                   
%  rotorpar.bearing_sitiff,rotorpar.bearing_sitiff,rotorpar.bearing_pos3,rotorpar.bearing_stiff_ang;
%                                        rotorpar.bearing_sitiff,rotorpar.bearing_sitiff,rotorpar.bearing_pos4,rotorpar.bearing_stiff_ang                                  
%add bearingstiffnes to the stiffnesmatrix 

K=K+Kb+Tb;

%gyroskopic matrix
G = compute_gyroscopic_matrix(rotorpar, moment_of_inertia,nodes);
% N = compute_cor_matrix(rotorpar, moment_of_inertia,nodes);
% G=2*G;
% G=G+N;
% %add Disc to G
% n1=find(abs(nodes-z1)<1e-4);
% assert(length(n1)==1);
% G(2*n1,2*n_nodes+2*n1)=G(2*n1,2*n_nodes+2*n1)-Iz1;
% G(2*n_nodes+2*n1,2*n1)=G(2*n_nodes+2*n1,2*n1)+Iz1;
% 
% n1=find(abs(nodes-z2)<1e-4);
% assert(length(n1)==1);
% G(2*n1,2*n_nodes+2*n1)=G(2*n1,2*n_nodes+2*n1)-Iz2;
% G(2*n_nodes+2*n1,2*n1)=G(2*n_nodes+2*n1,2*n1)+Iz2;


% 
% for n=1:(k2-k1)
% 
%  
%     
% n1=find(abs(nodes-nodes(k1+(n-1)))<1e-4);
% assert(length(n1)==1);
% G(2*n1,2*n_nodes+2*n1)=G(2*n1,2*n_nodes+2*n1)-Iz3;
% G(2*n_nodes+2*n1,2*n1)=G(2*n_nodes+2*n1,2*n1)+Iz3;
%  
% 
% end
%stiffn


% damping matrix 
% Dämpfung noch nicht betrachtet, da hier wegen hoher Dämpfung der
% Dichtung vernachlässig
%D = sparse(4*n_nodes,4*n_nodes);
D=zeros(4*n_nodes);%*(40/(4*n_nodes));


[EV,EW]=eig(K,M);
EW=(EW)^0.5/2/pi;

disp((EW(1,1)))
disp((EW(3,3)))
disp((EW(5,5)))

%% ========================================================================
%Load forces

%% ========================================================================

                  %[position[m],m*e[kg*m],psi[rad]     m   = mass, 
unbalance_mass_1 = [300e-3       ,5e-3    ,      0];  %e   = displacement
                                                      %psi = angle
 
                    %[Fx[N],Fy[N],Position[m]]                                                   
constant_fix_force = [   0, 0,    100e-3   ]; 


                         %[position[m],force[N],psi[rad]
constant_rotating_force = [0     ,0 ,      0];

omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 

h.h = zeros(4*length(nodes),1);   
 
%centripetal-force unbalance, rotating
h.h_ZPsin = h.h;                                      
h.h_ZPcos = h.h;   

%unbalance mass inertia force 
h.h_DBsin = h.h;                                 
h.h_DBcos = h.h;


%Constant_fix_force   e.g wight force
h.h_sin = h.h;                     
h.h_cos = h.h;


%rotating_fix_force%   e.g  bearing exitation 
h.h_rotsin = h.h;                   
h.h_rotcos = h.h;

%UNBALANCE% centripetal-force and mass inertia force
[h] = add_unbalance_mass(h, unbalance_mass_1, rotorpar, nodes, moment_of_inertia);

%constant_fix_force%   e.g wight force

[h] = add_constant_fix_force(h,constant_fix_force,rotorpar, nodes, moment_of_inertia);

%rotating_fix_force%   e.g  bearing exitation 

[h] = add_unbalance_mass(h, constant_rotating_force,  rotorpar,  nodes,  moment_of_inertia);

%% ========================================================================
%modal reduction

%% ========================================================================
% reduziert das system auf oben gewählte Anzahl an Freiheitsgraden, 
% liefert reduziete Systemmatrizen, Eigenvektoren und Eigenwerte für das
% ungedämpfte, trockene system.
% Eigenwert- und Eigenvektroberechnung erfolgt mit Matrizen des trockenen
% rotors

% Wird modal_reduction = 0 gewählt erfolgt keine reduzierung und            
% die Funktion liefert nicht reduzierte Matrizen

[M,K,G,~,h,EVmr,EWmr] = compute_modal_reduction_rotor_only(M,K,G,D,h,moden,modal_reduction);



D=0.01*M+0.0002*K;

%% ========================================================================
%System integration

%% ========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
method = 1;             %% 0 == stationär;  1 == instationär


time = 0:1e-4:2;        % time steps [S]
             

phi    = 0;             % phi        [rad]
omega  = 0;       % omega_ode  [rad/s] 

domega = 250;           %domega_ode  [rad/s^2]


Z0 = cumpute_Z0_rotor(M,phi, omega,domega,method); %init vector


% solver parameters

% options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6, 'OutputFcn','odeprint','OutputSel',1);
% % ODE function
% 
% [T,Z] = ode15s(@rotor_sys_function,time,Z0,options,K,M,D,G,h,omega_rot_const_force,method);
% 

%% ======================================================================== 
%  modal back transformation 
%                            
%% ========================================================================
%Funktion liefert Vektoren mit Verschiebungen bzw. Verdrehungen und deren
%Geschwindigkeiten in kartesischen Koordinatenan an allen Knoten für alle Zeitschritte

% [X,X_d,x,x_d,beta,beta_d,y,y_d,alpha,alpha_d,omega_ode,phi_ode] = modal_back_transformation(Z,M,EVmr);


%X          alle Verschiebungen und Biegewinkel 
%X_d        alle Geschwindigkeiten und Winkelgeschwindigkeiten der Biegung

% x         Verschiebungen in x-Richtung  
% Beta      Verdrehung um y 
% y         Verschiebung in y-Richtung
% alpha     Verdrehung um x

% x_d       Geschwindigkeit in x-Richtung 
% beta_d    Winkelgeschwindigkeit um y 

% y_d       Geschwindigkeit in y-Richtung  
% alpha_d   Winkelgeschwindigkeit um x 

% omega_ode Winkelgeschwindigkeit für ODE
% phi_ode   Phase                 für ODE


%% ========================================================================
% calculation of displacement at required rotor position z_pos 
%
%% ========================================================================

% z_pos = 0.25;   %position at rotor axis 
% % 
 %[x_pos,beta_pos,y_pos,alpha_pos] = displasment_calc_at_pos(z_pos,X,rotorpar,moment_of_inertia,nodes);
% % 
% 

%% AUSWERTUNG AMPLITUDE IN-STATIONÄR

%% =======================================================================================================================
% ts = 1;        %Startzeit in 1e-4 s  (1e-4 = Abtastrate^-1)
% te = 20000;    %Endzeit   in 1e-4 s    
% n_k =33;       % Knotennummer
% 
% 
% [Vinst] = amplitude_instat(x,y,Z,ts,te,n_k);
% 
% 



%% ========================================================================

% Hochlauf Stationär
%% ========================================================================


% omega_ramp = 100:100:1000;
% %  
% [ramp_up,a] = ode_hochlauf_trocken(omega_ramp,time,options,K,M,D,G,h,omega_rot_const_force,EVmr,nodes,rotorpar,moment_of_inertia,Z0);% % % 
% 
% 
% 

%% AUSWERTUNG AMPLITUDE STATIONÄR

%% =======================================================================================================================

% ts = 7000;          %% t1 sind Rechenschritte die für Ampl. plot VERWORFEN werden. von t1 bis Ende
%                     
% xk = 33;            %%  X Knoten 
% 
% yk = 33;             %% Y Knoten  
% ramp_up.omega_ramp =100:100:1000;
% 
% [V] = amplitude_stat(ts,ramp_up,xk,yk);


%% ========================================================================
%Hochlauf/gyroskopische Einflüssplot(Z(2315,1:2:22))e Rotor ohne Stoerungen
%%% SYSTEM NICHT REDUZIEREN!!!!!!!!!!!!!!!!!!!!!!!!!

%% ========================================================================
% 
omega =315;
n_ew = 5; % Anzahl der EW
% % % % 
% % % % %Berechnet die EV und EW über polyeig
% % % % %speichert die Anzahl n_we der Eigenvekroren und Eigenwerte in Aev/Aew
% % % % 
[Aev,Aew] = compute_EW_EV(omega,n_ew,K,G,M,n_nodes);
EVomega=1;
% 
EV_plot = plot_EV_EW(rotorpar,Aev,Aew,nodes,omega,EVomega,n_ew);
% 
% 
% 
% % surf(T(:),nodes,x(:,:))




