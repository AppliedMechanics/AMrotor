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
% start- and end-node
cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
    [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]};
clear rW rS


%% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% Number of refinement steps between d_min and d_max
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10;
cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% Definition of the element radius, if the geometry radius is not ...
% constant in this section. Options: symmetric, mean, upper sum, lower sum
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';
    
%% ====================Sensors============================================
%% Initialization of the sensor section in the struct
cnfg.cnfg_sensor=[];
count = 0;

% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'DisplBearing1';
% cnfg.cnfg_sensor(count).position=0e-3; % [m]
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='DisplDiscCenter';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='AngleDiscSensor';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='Anglesensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='AngleVelocDiscCenter';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='AngularVelocitysensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='DisplBearing2';
% cnfg.cnfg_sensor(count).position=500e-3; % [m]
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='VelocDiscCenter';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='Velocitysensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='AccelDiscCenter';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='Accelerationsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='ForceDiscCenter';
cnfg.cnfg_sensor(count).position=250e-3; % [m]
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='ForcePerturb';
% cnfg.cnfg_sensor(count).position=100e-3; % [m]
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='ForceBearing1';
% cnfg.cnfg_sensor(count).position=0e-3; % [m]
% cnfg.cnfg_sensor(count).type='BearingForceSensor';

%% =========================Components====================================
%% Initialization of the components section in the struct
count = 0;
cnfg.cnfg_component = []; 

%% Bearings
count = count + 1;
cnfg.cnfg_component(count).name = 'AxBearingLeft';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).position=500e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0;

count = count + 1;
cnfg.cnfg_component(count).name = 'TorqueBearingLeft';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
cnfg.cnfg_component(count).damping = 0;

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

% % Force in constant direction
% count = count + 1;
% cnfg.cnfg_load(count).name='ConstForce';
% cnfg.cnfg_load(count).position=250e-3;
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unbalance
count = count + 1;
cnfg.cnfg_load(count).name = 'SmallUnbalance';
cnfg.cnfg_load(count).position = 250e-3;
cnfg.cnfg_load(count).betrag = 1;
cnfg.cnfg_load(count).winkellage = 30/180*pi; % angle
cnfg.cnfg_load(count).width = 10e-3;
cnfg.cnfg_load(count).length = 70e-3;
cnfg.cnfg_load(count).type='Unbalance_static';

% % Sinusoidal excitation force
% count = count + 1;
% cnfg.cnfg_load(count).name='SinForce';
% cnfg.cnfg_load(count).position=250e-3; 
% cnfg.cnfg_load(count).betrag_x= 100;
% cnfg.cnfg_load(count).frequency_x= 50; % [Hz]
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% % Whirl excitation force
% count = count + 1;
% cnfg.cnfg_load(count).name='WhirlForce';
% cnfg.cnfg_load(count).position=250e-3; 
% cnfg.cnfg_load(count).t_start = 0; % start time [s]
% cnfg.cnfg_load(count).t_end = 10; % end time [s]
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 20; % [Hz]
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd';

% % Chirp, Sinus sweep force
% count = count + 1;
% cnfg.cnfg_load(count).name='ChirpForce';
% cnfg.cnfg_load(count).position=250e-3; 
% cnfg.cnfg_load(count).betrag_x= 1; % force amplitude x
% cnfg.cnfg_load(count).frequency_x_0 = 0; % start frequency x [Hz]
% cnfg.cnfg_load(count).frequency_x= 200; % end frequency x [Hz]
% cnfg.cnfg_load(count).betrag_y= 0; % force amplitude y
% cnfg.cnfg_load(count).frequency_y_0 = 0; % start frequency y [Hz]
% cnfg.cnfg_load(count).frequency_y= 0; % end frequency y [Hz]
% cnfg.cnfg_load(count).t_start= 0; % start time [s]
% cnfg.cnfg_load(count).t_end= 0.5; % end time [s]
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % Chirp, Sinus sweep force
% count = count + 1;
% cnfg.cnfg_load(count).name='ChirpForce';
% cnfg.cnfg_load(count).position=250e-3; 
% cnfg.cnfg_load(count).betrag_x= 1; % force amplitude x
% cnfg.cnfg_load(count).frequency_x_0 = 0; % start frequency x [Hz]
% cnfg.cnfg_load(count).frequency_x= 200; % end frequency x [Hz]
% cnfg.cnfg_load(count).betrag_y= 0; % force amplitude y
% cnfg.cnfg_load(count).frequency_y_0 = 0; % start frequency y [Hz]
% cnfg.cnfg_load(count).frequency_y= 0; % end frequency y [Hz]
% cnfg.cnfg_load(count).t_start= 0.5; % start time [s]
% cnfg.cnfg_load(count).t_end= 1; % end time [s] 
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % Chirp, Sinus sweep force
% count = count + 1;
% cnfg.cnfg_load(count).name='ChirpForce';
% cnfg.cnfg_load(count).position=0e-3; 
% cnfg.cnfg_load(count).betrag_x= 0.1; % force amplitude x
% cnfg.cnfg_load(count).frequency_x_0 = 400; % start frequency x [Hz]
% cnfg.cnfg_load(count).frequency_x= 500; % end frequency x [Hz]
% cnfg.cnfg_load(count).betrag_y= 0; % force amplitude y
% cnfg.cnfg_load(count).frequency_y_0 = 0; % start frequency y [Hz]
% cnfg.cnfg_load(count).frequency_y= 0; % end frequency y [Hz]
% cnfg.cnfg_load(count).t_start= 0; start time [s]
% cnfg.cnfg_load(count).t_end= 1; end time [s]
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % Forward whirl sweep force
% count = count + 1;
% cnfg.cnfg_load(count).name='FwdWhirlSweepForce';
% cnfg.cnfg_load(count).position=100e-3; 
% cnfg.cnfg_load(count).betrag_x= 0.2; % force amplitude x
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;; % force ...
                                                            % amplitude y
% cnfg.cnfg_load(count).frequency_0 = 0; % start frequency [Hz]
% cnfg.cnfg_load(count).frequency= 200; % end frequency [Hz]
% cnfg.cnfg_load(count).t_start= 0.45; % start time [s]
% cnfg.cnfg_load(count).t_end= 0.5; % end time [s]
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% % Backward whirl sweep force
% count = count + 1;
% cnfg.cnfg_load(count).name='BwdWhirlSweepKraft';
% cnfg.cnfg_load(count).position=pos.ML1; 
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % start frequency [Hz]
% cnfg.cnfg_load(count).frequency= 200; % end frequency [Hz]
% cnfg.cnfg_load(count).t_start= 0.5; % start time [s]
% cnfg.cnfg_load(count).t_end= 1.0; % end time [s]
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';

% % Muszynska-Seal laminar
% count = count + 1;
% cnfg.cnfg_load(count).name = 'MuszynskaSealMittig';
% cnfg.cnfg_load(count).position=pos.DicMitte; % [m]
% cnfg.cnfg_load(count).type='MuszynskaLaminarSeal';
% cnfg.cnfg_load(count).sealModel = load_seal_model('Inputfiles/ ...
%                                               TestRigNeu1.m');

% % Lim-Singh-bearing
% count = count + 1;
% cnfg.cnfg_load(count).name = 'LimSingh1';
% cnfg.cnfg_load(count).position=pos.Lag1; % [m]
% cnfg.cnfg_load(count).type='LimSinghBearing';
% cnfg.cnfg_load(count).par = load_bearing_LimSingh('Inputfiles/ ... 
%                                               parametersGupta20mm.m'); 

% % Lim-Singh-bearing
% count = count + 1;
% cnfg.cnfg_load(count).name = 'LimSingh2';
% cnfg.cnfg_load(count).position=pos.Lag2; % [m]
% cnfg.cnfg_load(count).type='LimSinghBearing';
% cnfg.cnfg_load(count).par = load_bearing_LimSingh('Inputfiles/ ... 
%                                               parametersGupta20mm.m'); 

%% ========================PID-controller==================================
%% Initialization of the pid-controller section in the struct
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing===========================
%% Initialization of the active magnetic bearing section in the struct
cnfg.cnfg_activeMagneticBearing = [];
count = 0;