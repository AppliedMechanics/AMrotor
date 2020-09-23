%% ================Rotor===================================================

%% Building of the rotor struct
cnfg.cnfg_rotor.name = 'Simple example: Laval-Rotor';
% All units in SI 
cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3]
cnfg.cnfg_rotor.material.poisson  = 0.3;    %[-]
% Rayleigh damping: D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1e-5;
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 10;

%% Rotor Config
rW = 10e-3; % Radius of the shaft [m]
rS = 50e-3; % Radius of the disc [m]
% Format of the geometry definition: {[z, r_outer, r_inner], ...} without..
% start- and end-node:
cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
    [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]};
clear rW rS


%% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% Number of refinement steps between d_min and d_max:
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10;
cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% Definition of the element radius, if the geometry radius is not ...
% constant in this section. Options: symmetric, mean, upper sum, lower sum:
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';
   
%% ====================Sensors============================================
%% Initialization of the sensor section in the struct
cnfg.cnfg_sensor=[];
count = 0;

%% =========================Components====================================
%% Initiation of the components section in the struct
count = 0;
cnfg.cnfg_component = []; 

%% Bearings
count = count + 1;
cnfg.cnfg_component(count).name = 'AxBearingLeft';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).position=500e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'TorqueBearingLeft';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'IsotropBearing1';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'IsotropBearing2';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=500e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

% count = count+1;
% cnfg.cnfg_component(count).name = 'Rigid clamping';
% cnfg.cnfg_component(count).position=0e-3; % [m]
% cnfg.cnfg_component(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_component(count).stiffness=1e10; % [N/m]
% cnfg.cnfg_component(count).damping = 0;

%% =========================Loads=========================================
%% Initialization of the load section in the struct
cnfg.cnfg_load=[];
count = 0;

%% ========================PID-controller==================================
%% Initialization of the pid-controller section in the struct
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing===========================
%% Initialization of the active magnetic bearing section in the struct
cnfg.cnfg_activeMagneticBearing = [];
count = 0;