%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Einfaches Beispiel: Laval-Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

% Rotor Config
rW = 10e-3; % Radius der Welle
rS = 50e-3; % Radius der Scheibe

% cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
%     [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten
% cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.500 rW 0]};
cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.2 rW 0], [0.2 50e-3 0], [0.3 50e-3 0], [0.3 rW 0], [0.500 rW 0]};
% cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.120 rW 0], [0.120 rS 0], [0.130 rS 0], [0.130 rW 0], [0.245 rW 0], [0.245 rS 0], [0.255 rS 0], [0.255 rW 0], [0.370 rW 0], [0.370 rS 0], [0.380 rS 0], [0.380 rW 0] [0.500 rW 0]}; % Mehrscheiben
clear rW rS


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.009;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';%'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.004;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.02;
% cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';%'upper sum';%'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];


%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'WegLager1';
cnfg.cnfg_sensor(count).position=0e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegScheibeMitte';
cnfg.cnfg_sensor(count).position=250e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegLager2';
cnfg.cnfg_sensor(count).position=500e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];
count = 0; 

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;
% 
count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=500e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

% count = count+1;
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% 
% count = count+1;
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=500e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;


%% ========================================================================
cnfg.cnfg_load=[];


%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];

%% ========================================================================
% Dichtungen, Zeitbereich
count = 0;
cnfg.cnfg_sealNonLinear = [];