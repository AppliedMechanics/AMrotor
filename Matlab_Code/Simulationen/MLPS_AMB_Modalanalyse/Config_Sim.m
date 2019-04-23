%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

% % Rotor Config
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.3495 0.004 0], [0.3495 0.069 0], [0.3605 0.069 0], [0.3605 0.004 0], [0.695 0.004 0], [0.695 0 0]};

% Rotor Config inkl. Lagerhuelsen
% Lagerhuelsen
%   mL = 0.940 kg aus MA Maierhofer
%   rL = 32.5 mm aus Berechnung mit Masse
%   lL = 38 mm aus CAD
%   Lagerhuelse 1: Mittelpunkt bei 110 mm (aus Config_file unten), zleft=91mm, zright=129mm 
%   Lagerhuelse 2: Mittelpunkt bei 630 mm, zleft=611mm, zright=649mm
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
%     [0.091 0.0325 0], [0.129 0.0325 0], [0.129 0.004 0], ... % Lagerhuelse 1
%     [0.3495 0.004 0], [0.3495 0.069 0], [0.3605 0.069 0], [0.3605 0.004 0],... % Rotorscheibe
%     [0.611 0.004 0], [0.611 0.0325 0], [0.649 0.0325 0], ... % Lagerhuelse 2
%     [0.649 0.004 0], [0.695 0.004 0], [0.695 0 0]}; % Welle

% rumgetuefftelt:
raL = 0.04
riL = sqrt(raL^2-0.940/7446/pi/0.038)
raR = 0.09
riR = sqrt(raR^2-1.235/7446/pi/0.011)
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
    [0.091 0.04 0.01], [0.129 0.04 0.01], [0.129 0.004 0], ... % Lagerhuelse 1
    [0.3495 0.004 0], [0.3495 0.09 0.06], [0.3605 0.09 0.06], [0.3605 0.004 0],... % Rotorscheibe
    [0.611 0.004 0], [0.611 0.04 0.01], [0.649 0.04 0.01], ... % Lagerhuelse 2
    [0.649 0.004 0], [0.695 0.004 0], [0.695 0 0]}; % Welle


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.

    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];

% cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
% cnfg.cnfg_disc(1).position = 300e-3;                 %disc position [m]
% cnfg.cnfg_disc(1).radius = 200e-3;  
% cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
% cnfg.cnfg_disc(1).Jx = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jz = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jp = 1;                         %disc polar mom. of inertia [kg*m^2]

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'WegLager1';
cnfg.cnfg_sensor(count).position=0.110;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegWelle1';
cnfg.cnfg_sensor(count).position=0.200;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegScheibe';
cnfg.cnfg_sensor(count).position=0.355;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegWelle2';
cnfg.cnfg_sensor(count).position=0.500;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegLager2';
cnfg.cnfg_sensor(count).position=0.630;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftLager1';
cnfg.cnfg_sensor(count).position=0.110;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftScheibe';
cnfg.cnfg_sensor(count).position=0.355;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftLager2';
cnfg.cnfg_sensor(count).position=0.630;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];

count = 1;
cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=110e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=630e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;


%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft';
% cnfg.cnfg_load(count).position=0e-3;
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
count = count + 1;
cnfg.cnfg_load(count).name = 'Kleine Unwucht';
cnfg.cnfg_load(count).position = 280e-3;
cnfg.cnfg_load(count).betrag = 1e-6;%5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusförmige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% Whirl, Anregungskraft beschreibt Ellipse
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 500;  %in Hz
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd';

% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% whirl-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
cnfg.cnfg_load(count).position=138e-3; % Position ML 1
cnfg.cnfg_load(count).betrag_x= 1;
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 1000;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_end= 0.6;%2; % Zeitdauer des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

%% ========================================================================
% Dichtungen
cnfg.cnfg_seal = [];