%% ================Rotor===================================================

cnfg.cnfg_rotor.name = 'MBTR - TestRig';
cnfg.cnfg_rotor.color = AMrotorTools.TUMColors.TUMGray2; % Rotor color
% All units in SI 
cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9; % [N/m^2]
cnfg.cnfg_rotor.material.density  = 7860; % [kg/m^3]
cnfg.cnfg_rotor.material.poisson  = 0.3; % [-]
% Rayleigh damping: D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 5e-7;
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;

%% Rotor Config
% % Only main shaft radius, shaft steps as disc components
% raW = 0.004;
% % Format of the geometry definition: {[z, r_outer, r_inner], ...} ...
% % without start- and end-node:
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW 0], [0.702 raW 0]};

% Shaft with reinforcements at the bearing journals and at the disc
raW = 0.004;
riW = 0;
raL = raW*1.2;
riL = 0;
raR = raW*1.2;
riR = 0;
% Format of the geometry definition: {[z, r_outer, r_inner], ...} without..
% start- and end-node:
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW riW], [0.094 raW riW], ... 
    [0.094 raL riL], [0.132 raL riL], [0.132 raW riW], ... 
    [0.350 raW riW], [0.350 raR riR], [0.376 raR riR], [0.376 raW riW],... 
    [0.604 raW riW], [0.604 raL riL], [0.642 raL riL], ... 
    [0.642 raW riW], [0.702 raW riW], [0.702 0 0]}; 

% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW riW], [0.094 raW riW], ... 
%                                                      % Shaft
%     [0.094 raL riL], [0.132 raL riL], [0.132 raW riW], ... 
%                                                      % bearing bushing 1
%     [0.350 raW riW], [0.350 raR riR], [0.376 raR riR], [0.376 raW riW],... 
%                                                      % Rotor disc
%     [0.604 raW riW], [0.604 raL riL], [0.642 raL riL], ... 
%                                                      % bearing bushing 2
%     [0.642 raW riW], [0.702 raW riW], [0.702 0 0]}; % Shaft

%% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% Number of refinement steps between d_min and d_max:
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.01;
% Definition of the element radius, if the geometry radius is not ...
% constant in this section. Options: symmetric, mean, upper sum, lower sum:
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';
    
%% =========================Components====================================
%% Initiation of the components section in the struct
count = 0;
cnfg.cnfg_component = [];  

%% Disc
count = count+1;
cnfg.cnfg_component(count).name = 'AMB_rotor_L'; % incl. clamping sleeve 
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = 113e-3; % [m]
cnfg.cnfg_component(count).radius = 46e-3; % [m] only for visualization 
cnfg.cnfg_component(count).width = 0e-3; % only for visualization
cnfg.cnfg_component(count).color = AMrotorTools.TUMColors.TUMBlue; % color              
cnfg.cnfg_component(count).m = 0.85074; % disc mass [kg]
cnfg.cnfg_component(count).Jx = 4.840066e-4; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 4.036839e-4; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz; % disc ... 
                                            %polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_component(count).name = 'Center disc'; % incl. clamping ... 
                                                  % sleeve, screws, nuts,..
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = 363e-3; % [m]
cnfg.cnfg_component(count).radius = 96e-3; % [m], only for visualization       
cnfg.cnfg_component(count).width = 10e-3; % only for visualization
cnfg.cnfg_component(count).color = AMrotorTools.TUMColors.TUMBlue; % color
cnfg.cnfg_component(count).m = 1.276499; % disc mass [kg]
cnfg.cnfg_component(count).Jx = 1.487212e-3; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 2.832751e-3; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz; % disc ... 
                                            %polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_component(count).name = 'AMB_rotor_R'; % incl. clamping sleeve
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = 623e-3; % [m]
cnfg.cnfg_component(count).radius = 46e-3; % [m], only for visualization 
cnfg.cnfg_component(count).width = 0e-3; % only for visualization
cnfg.cnfg_component(count).color = AMrotorTools.TUMColors.TUMBlue; % color
cnfg.cnfg_component(count).m = 0.85074; % disc mass [kg]
cnfg.cnfg_component(count).Jx = 4.840066e-4; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = 4.036839e-4; % disc mom. of ...
                                             % inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz; % disc ... 
                                            %polar mom. of inertia [kg*m^2]

%% Bearings
% for in MBTR integrated rotor

kSchaetzung = 3.5e4; % estimated stiffness [N/m]
dSchaetzung = 90; % estimated damping [Ns/m]
kML = kSchaetzung;
dML = dSchaetzung;

count = count +1;
cnfg.cnfg_component(count).name = 'AxBearingLeft';
cnfg.cnfg_component(count).position=113e-3; % [m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).stiffness=1e10; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'TorqueBearingLeft';
cnfg.cnfg_component(count).position=113e-3; % [m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).stiffness=1e10; % [N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'IsotropBearing1';
cnfg.cnfg_component(count).position=113e-3; % [m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).stiffness=kML; % [N/m]
cnfg.cnfg_component(count).damping = dML; % [Ns/m]
cnfg.cnfg_component(count).color = AMrotorTools.TUMColors.TUMOrange;

count = count + 1;
cnfg.cnfg_component(count).name = 'IsotropBearing2';
cnfg.cnfg_component(count).position=623e-3; % [m]
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).stiffness=kML; % [N/m]
cnfg.cnfg_component(count).damping = dML; % [Ns/m]
cnfg.cnfg_component(count).color = AMrotorTools.TUMColors.TUMOrange;

%% ====================Sensors============================================
%% Initialization of the sensor section in the struct
cnfg.cnfg_sensor=[];
count = 0;

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL1';
cnfg.cnfg_sensor(count).position=0.071; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'DisplAMBL';
cnfg.cnfg_sensor(count).position=0.113; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL2';
cnfg.cnfg_sensor(count).position=0.155; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Laser';
cnfg.cnfg_sensor(count).position=0.363; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR1';
cnfg.cnfg_sensor(count).position=0.581; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='DisplAMBL';
cnfg.cnfg_sensor(count).position=0.623; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR2';
cnfg.cnfg_sensor(count).position=0.665; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

%% =========================Loads=========================================
%% Initialization of the load section in the struct
cnfg.cnfg_load=[];
count = 0;

% Unbalance
count = count + 1;
cnfg.cnfg_load(count).name = 'SmallUnbalance';
cnfg.cnfg_load(count).position = 363e-3; % [m]
cnfg.cnfg_load(count).betrag = 1e-4;
cnfg.cnfg_load(count).winkellage = pi/4; % angle
cnfg.cnfg_load(count).type='Unbalance_static';
cnfg.cnfg_load(count).width=0.01;
cnfg.cnfg_load(count).length=0.1;

% Forward whirl sweep force
count = count + 1;
cnfg.cnfg_load(count).name='FwdWhirlSweepForce';
cnfg.cnfg_load(count).position=113e-3; % position AMB 1 [m]
cnfg.cnfg_load(count).betrag_x= 1; % force amplitude x
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x; % force ...
                                                            % amplitude y
cnfg.cnfg_load(count).frequency_0 = 0; % start frequency [Hz]
cnfg.cnfg_load(count).frequency= 250; % end frequency [Hz]
cnfg.cnfg_load(count).t_start = 0; % start time [s]
cnfg.cnfg_load(count).t_end= 0.8; % end time [s]
cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

%% ========================PID-controller==================================
%% Initialization of the pid-controller section in the struct
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing===========================
%% Initialization of the active magnetic bearing section in the struct
cnfg.cnfg_activeMagneticBearing = [];
count = 0;