%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Einfacher Balken';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

% Rotor Config
beamLength = 0.5; %0.5 Meter
radius = 10e-3; % 20 Millimeter
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 radius 0], [beamLength radius 0]};
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 radius 0], [0.15 radius 0], [0.15 30e-3 radius/2], [0.35 30e-3 0], [0.40 radius 0], [0.42 radius 0], [0.42 radius/2 0],  [beamLength radius/2 0]};

% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric. 
%                                 % 'symmetric' eighnet sich besonders gut fuer Spruenge
cnfg.cnfg_rotor.mesh_opt.name = 'grobes Netz';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.02;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';
    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];
count = 0;

% cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
% cnfg.cnfg_disc(1).position = 250e-3;                 %disc position [m]
% cnfg.cnfg_disc(1).radius = 60e-3;  
% cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
% cnfg.cnfg_disc(1).Jx = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jz = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jp = 1;                         %disc polar mom. of inertia [kg*m^2]

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0;

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];

count = 1;
cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = 2;
cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
cnfg.cnfg_bearing(count).position=beamLength;                        %[m]
cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;


%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];
