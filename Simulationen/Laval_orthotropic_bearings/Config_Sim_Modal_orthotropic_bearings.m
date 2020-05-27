%% ================Rotor===================================================
% Aufbau eines Structs mit den Rotordaten
cnfg.cnfg_rotor.name = 'Einfaches Beispiel: Laval-Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1e-5;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 10;

% Rotor Config
rW = 10e-3; % Radius der Welle [m]
rS = 50e-3; % Radius der Scheibe [m]

cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
    [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten [m]
clear rW rS


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.001; %[m]
cnfg.cnfg_rotor.mesh_opt.d_max = 0.009; % [m]
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.
    
%% ====================Sensoren============================================
cnfg.cnfg_sensor=[];
count = 0;

%% =========================Komponenten====================================
count = 0;
cnfg.cnfg_component = []; 

%% Lager

count = count + 1;
cnfg.cnfg_component(count).name = 'Axiales Lager Links';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

count = count + 1;
cnfg.cnfg_component(count).name = 'Torque Lager Links';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

% count = count + 1;
% cnfg.cnfg_component(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_component(count).type='Bearings';
% cnfg.cnfg_component(count).subtype='SimpleBearing';
% cnfg.cnfg_component(count).position=0e-3; % [m]
% cnfg.cnfg_component(count).stiffness=1e6;                    %[N/m]
% cnfg.cnfg_component(count).damping = 0; % [Ns/m]
% 
% count = count + 1;
% cnfg.cnfg_component(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_component(count).type='Bearings';
% cnfg.cnfg_component(count).subtype='SimpleBearing';
% cnfg.cnfg_component(count).position=500e-3; % [m]
% cnfg.cnfg_component(count).stiffness=1e6;                   %[N/m]
% cnfg.cnfg_component(count).damping = 0; % [Ns/m]

%% Anisotropic bearings
kx = 1e6;
ky = 1e8;
dx = 0;
dy = 0;
count = count + 1;
cnfg.cnfg_component(count).name = 'Ansotropes Lager 1';
cnfg.cnfg_component(count).type='CompInvariantMCK'; %independent of rpm, time, ...
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness_matrix= diag([kx ky 0 0 0 0]);                   %[N/m]
cnfg.cnfg_component(count).damping_matrix = diag([dx dy 0 0 0 0]); % [Ns/m]
cnfg.cnfg_component(count).mass_matrix = diag([0 0 0 0 0 0]); % [kg]


count = count + 1;
cnfg.cnfg_component(count).name = 'Anisotropes Lager 2';
cnfg.cnfg_component(count).type='CompInvariantMCK'; %independent of rpm, time, ...
cnfg.cnfg_component(count).position=300e-3; % [m]
alp = pi/6;
A = [cos(alp), -sin(alp), 0; sin(alp), cos(alp), 0; 0 0 1]; %Drehmatrix
T = [A, zeros(3); zeros(3), eye(3)];
cnfg.cnfg_component(count).stiffness_matrix= T'*diag([kx ky 0 0 0 0])*T;                   %[N/m]
cnfg.cnfg_component(count).damping_matrix = T'*diag([dx dy 0 0 0 0])*T; % [Ns/m]
cnfg.cnfg_component(count).mass_matrix = T'*diag([0 0 0 0 0 0])*T; % [kg]

count = count + 1;
cnfg.cnfg_component(count).name = 'Anisotropes Lager 3';
cnfg.cnfg_component(count).type='CompInvariantMCK'; %independent of rpm, time, ...
cnfg.cnfg_component(count).position=500e-3; % [m]
cnfg.cnfg_component(count).stiffness_matrix= diag([kx ky 0 0 0 0]);                   %[N/m]
cnfg.cnfg_component(count).damping_matrix = diag([dx dy 0 0 0 0]); % [Ns/m]
cnfg.cnfg_component(count).mass_matrix = diag([0 0 0 0 0 0]); % [kg]

% count = count+1;
% cnfg.cnfg_component(count).name = 'Feste Einspannung';
% cnfg.cnfg_component(count).position=0e-3;                        %[m]
% cnfg.cnfg_component(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_component(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_component(count).damping = 0;


%% =========================Lasten=========================================
cnfg.cnfg_load=[];
count = 0;

%% ========================PID-Regler======================================
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing===========================
cnfg.cnfg_activeMagneticBearing = [];
count = 0;