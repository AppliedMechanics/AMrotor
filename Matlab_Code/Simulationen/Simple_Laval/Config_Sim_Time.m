%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Einfaches Beispiel: Laval-Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0.001;

% Rotor Config
rW = 10e-3; % Radius der Welle
rS = 50e-3; % Radius der Scheibe

cnfg.cnfg_rotor.geo_nodes = {[0 rW], [0.220 rW], [0.220 rS], ...
    [0.280 rS], [0.280 rW], [0.500 rW]}; % Format {[z, r_aussen], ...} % ohne Anfangs und Endknoten
clear rW rS


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.02;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';%'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric. symmetric.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.004;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric. symmetric.
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';%'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric. symmetric.
    
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

% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftLager1';
% cnfg.cnfg_sensor(count).position=0e-3;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftScheibeMitte';
cnfg.cnfg_sensor(count).position=250e-3;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftLager2';
% cnfg.cnfg_sensor(count).position=500e-3;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];
count = 0;

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Torque Lager Links'; % Was macht das Torque Lager?
% cnfg.cnfg_bearing(count).position=250e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=0e-3;                       %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=500e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???


%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft';
% cnfg.cnfg_load(count).position=250e-3;
% cnfg.cnfg_load(count).betrag_x= 0;
% cnfg.cnfg_load(count).betrag_y= -10;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
count = count + 1;
cnfg.cnfg_load(count).name = 'Kleine Unwucht';
cnfg.cnfg_load(count).position = 250e-3;
cnfg.cnfg_load(count).betrag = 5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusfoermige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=250e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 100;
% cnfg.cnfg_load(count).frequency_x= 50;  %in Hz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% Whirl, Anregungskraft beschreibt Ellipse
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 500;  %in Hz
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd';

% Chirp, Sinus-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Chirp Kraft';
cnfg.cnfg_load(count).position=250e-3; % Position ML 1
cnfg.cnfg_load(count).betrag_x= 100;
cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency_x= 200;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).betrag_y= 0;
cnfg.cnfg_load(count).frequency_y_0 = 0;
cnfg.cnfg_load(count).frequency_y= 0;
cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % fwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Fwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= 0.5; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% 
% % bwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Bwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0.5;
% cnfg.cnfg_load(count).t_end= 1.0;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';
% 
% 