%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 6.1090e-05;%3.5834e-07;%0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 1.4707;%30;%1e7;%0.001;

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

% Rotor Config inkl. Lagerhuelsen SYMMETRISCH
% Lagerhuelsen
%   mL = 0.940 kg aus MA Maierhofer
%   rL = 32.5 mm aus Berechnung mit Masse
%   lL = 38 mm aus CAD
%   Lagerhuelse 1: Mittelpunkt bei 110 mm 
%   Lagerhuelse 2: Mittelpunkt bei 590 mm
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
%     [0.091 0.0325 0], [0.129 0.0325 0], [0.129 0.004 0], ... % Lagerhuelse 1
%     [0.3445 0.004 0], [0.3445 0.069 0], [0.3555 0.069 0], [0.3555 0.004 0],... % Rotorscheibe
%     [0.571 0.004 0], [0.571 0.0325 0], [0.609 0.0325 0], ... % Lagerhuelse 2
%     [0.609 0.004 0], [0.7 0.004 0], [0.7 0 0]}; % Welle

% getuefftelt 24.01.2019 Radius der Scheiben geringer und dafür zusätzliche
% Massescheiben, damit k geringer aber m gleich, andere Idee wäre Vorgabe
% des E-Moduls für jeden Abschnitt(elementweise)
% EF ABGESTIMMT MIT EXPERIMENTELL ERMITTELTEN, MAIERHOFER SIRM2019
% Lagerhuelsen
%   mL = 0.940 kg aus MA Maierhofer
%   rL = 32.5 mm aus Berechnung mit Masse
%   lL = 38 mm aus CAD
%   Lagerhuelse 1: Mittelpunkt bei 110 mm 
%   Lagerhuelse 2: Mittelpunkt bei 590 mm
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
    [0.091 0.0325*1.6 0], [0.129 0.0325*1.6 0], [0.129 0.004 0], ... % Lagerhuelse 1
    [0.3445 0.004 0], [0.3445 0.069*1.3 0], [0.3555 0.069*1.3 0], [0.3555 0.004 0],... % Rotorscheibe
    [0.571 0.004 0], [0.571 0.0325*1.6 0], [0.609 0.0325*1.6 0], ... % Lagerhuelse 2
    [0.609 0.004 0], [0.7 0.004 0], [0.7 0 0]}; % Welle

% % rumgetuefftelt:
% raL = 0.04
% riL = sqrt(raL^2-0.940/7446/pi/0.038)
% raR = 0.09
% riR = sqrt(raR^2-1.235/7446/pi/0.011)
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
%     [0.091 0.04 0.01], [0.129 0.04 0.01], [0.129 0.004 0], ... % Lagerhuelse 1
%     [0.3495 0.004 0], [0.3495 0.09 0.06], [0.3605 0.09 0.06], [0.3605 0.004 0],... % Rotorscheibe
%     [0.611 0.004 0], [0.611 0.04 0.01], [0.649 0.04 0.01], ... % Lagerhuelse 2
%     [0.649 0.004 0], [0.695 0.004 0], [0.695 0 0]}; % Welle


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.01;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.

    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];
count = 0;

% count = count+1;
% cnfg.cnfg_disc(count).name = 'Lagerhuelse1';
% cnfg.cnfg_disc(count).position = 110e-3;                 %disc position [m]
% cnfg.cnfg_disc(count).radius = 32.5e-3;  
% cnfg.cnfg_disc(count).m = 0.1784;                             %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  
% 
% count = count+1;
% cnfg.cnfg_disc(count).name = 'Lagerhuelse2';
% cnfg.cnfg_disc(count).position = 590e-3;                 %disc position [m]
% cnfg.cnfg_disc(count).radius = 32.5e-3;  
% cnfg.cnfg_disc(count).m = 0.1784;                             %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  
% 
% count = count+1;
% cnfg.cnfg_disc(count).name = 'Scheibe';
% cnfg.cnfg_disc(count).position = 350e-3;                 %disc position [m]
% cnfg.cnfg_disc(count).radius = 69e-3;  
% cnfg.cnfg_disc(count).m = 0.8041;                             %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0; 

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegLager1links';
cnfg.cnfg_sensor(count).position=0.110-0.085/2;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'WegLager1';
% cnfg.cnfg_sensor(count).position=0.110;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegLager1rechts';
cnfg.cnfg_sensor(count).position=0.110+0.085/2;
cnfg.cnfg_sensor(count).type='Displacementsensor';


count = count + 1;
cnfg.cnfg_sensor(count).name='WegScheibe';
cnfg.cnfg_sensor(count).position=0.350;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegLager2links';
cnfg.cnfg_sensor(count).position=0.590-0.085/2;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='WegLager2';
% cnfg.cnfg_sensor(count).position=0.590;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegLager2rechts';
cnfg.cnfg_sensor(count).position=0.590+0.085/2;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftLager1';
% cnfg.cnfg_sensor(count).position=0.110;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftScheibe';
% cnfg.cnfg_sensor(count).position=0.350;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
count = count + 1;
cnfg.cnfg_sensor(count).name='KraftLager2';
cnfg.cnfg_sensor(count).position=0.590;
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
cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=590e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
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

% % Unwuchten
% count = count + 1;
% cnfg.cnfg_load(count).name = 'Kleine Unwucht';
% cnfg.cnfg_load(count).position = 280e-3;
% cnfg.cnfg_load(count).betrag = 1e-6;%5e-6;
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';

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

% Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position= 590e-3; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 1e-2;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 300;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0.5e-2;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 4; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 1000;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_end= 0.6;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% 
% % Band limited white noise % does not yet work
% count = count + 1;
% cnfg.cnfg_load(count).name='Noise';
% cnfg.cnfg_load(count).position=590e-3; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 1e-2;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 250;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 4; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_limited_noise';

% Look Up Table Force Load, wird vorab aufgestellt und dann waehrend Laufzeit
% werden die Werte zu den gesuchten zeitpuntken interpoliert
count = count + 1;
cnfg.cnfg_load(count).name='Noise';
cnfg.cnfg_load(count).position=590e-3; % Position ML 2
% t = 0:1e-3:1;
% cnfg.cnfg_load(count).Table.time = t;
% cnfg.cnfg_load(count).Table.force{1} = 1e-2*sin(2*pi*30*t); %Fx [N]
% cnfg.cnfg_load(count).Table.force{2} = zeros(size(t)); %Fy [N]
% cnfg.cnfg_load(count).Table.force{3} = zeros(size(t)); %Fz [N]
% cnfg.cnfg_load(count).Table.force{4} = zeros(size(t)); %Mx [N]
% cnfg.cnfg_load(count).Table.force{5} = zeros(size(t)); %My [N]
% cnfg.cnfg_load(count).Table.force{6} = zeros(size(t)); %Mz [N]
% cnfg.cnfg_load(count).Table.time = load_force_table('Inputfiles/noise250Hz.mat'); 
load('Inputfiles/noise250Hz.mat')
cnfg.cnfg_load(count).Table.time = t;
cnfg.cnfg_load(count).Table.force{1} = 1e-2*x; %Fx [N]
cnfg.cnfg_load(count).Table.force{2} = 0*x; %Fy [N]
cnfg.cnfg_load(count).Table.force{3} = 0*x; %Fz [N]
cnfg.cnfg_load(count).Table.force{4} = 0*x; %Mx [N]
cnfg.cnfg_load(count).Table.force{5} = 0*x; %My [N]
cnfg.cnfg_load(count).Table.force{6} = 0*x; %Mz [N]
cnfg.cnfg_load(count).type='Force_timevariant_look_up';
clear t x
% ========================================================================
% Dichtungen
cnfg.cnfg_seal = [];