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
rW = 10e-3; % Radius der Welle
rS = 50e-3; % Radius der Scheibe

cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
    [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten
clear rW rS


cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';%'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.
    
    
%% ====================Sensoren============================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0;

count = count + 1;
cnfg.cnfg_sensor(count).name='WegScheibeMitte';
cnfg.cnfg_sensor(count).position=250e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftScheibeMitte';
cnfg.cnfg_sensor(count).position=250e-3;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='ReglerKraftScheibeMitte';
cnfg.cnfg_sensor(count).position=250e-3;
cnfg.cnfg_sensor(count).type='ControllerForceSensor';


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

count = count + 1;
cnfg.cnfg_component(count).name = 'Isotropes Lager 1';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=0e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6;                    %[N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]

count = count + 1;
cnfg.cnfg_component(count).name = 'Isotropes Lager 2';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=500e-3; % [m]
cnfg.cnfg_component(count).stiffness=1e6;                   %[N/m]
cnfg.cnfg_component(count).damping = 0; % [Ns/m]


%% =========================Lasten=========================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung, Sprung
count = count + 1;
cnfg.cnfg_load(count).name='Const. Kraft'; 
cnfg.cnfg_load(count).position=250e-3;
cnfg.cnfg_load(count).betrag_x= 1;
cnfg.cnfg_load(count).betrag_y= 0;
cnfg.cnfg_load(count).type='Force_constant_fix';

% Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=250e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 0;
% cnfg.cnfg_load(count).t_end= 0.5; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

%% ========================PID-Regler======================================
cnfg.cnfg_pid_controller=[];
count = 0;

electricalP=2e5/70;%15e4;
electricalI=2e5/70;%15e4;
electricalD=1e3/70;%7e2;

%% linear force-calculation
% ki = 70;%50;% % A/N
% 
% count = count + 1;
% cnfg.cnfg_pid_controller(count).name = 'Test-Regler x lin';
% cnfg.cnfg_pid_controller(count).position = 250e-3;
% cnfg.cnfg_pid_controller(count).direction = 'u_x';
% cnfg.cnfg_pid_controller(count).type = 'pidControllerLinear';
% cnfg.cnfg_pid_controller(count).ki = ki; % N/A
% cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
% cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
% cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
% cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m
% 
% count = count + 1;
% cnfg.cnfg_pid_controller(count).name = 'Test-Regler y lin';
% cnfg.cnfg_pid_controller(count).position = 250e-3;
% cnfg.cnfg_pid_controller(count).direction = 'u_y';
% cnfg.cnfg_pid_controller(count).type = 'pidControllerLinear';
% cnfg.cnfg_pid_controller(count).ki = ki; % N/A, specific for pidControllerLinear
% cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
% cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
% cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
% cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m

%% Polynommodell 2. Ordnung nach Dietz 2018 S. 58, Simulationsmodell
% A = [0, 103.04e6; 6e3, 0];
% B = [-0.01, 0; 0, -0.26e6];
% cT = [68.45, 209.28e3];
% d = -0.02; 
% 
% count = count + 1;
% cnfg.cnfg_pid_controller(count).name = 'Test-Regler x poly2';
% cnfg.cnfg_pid_controller(count).position = 250e-3;
% cnfg.cnfg_pid_controller(count).direction = 'u_x';
% cnfg.cnfg_pid_controller(count).type = 'pidControllerPolynomial2';
% cnfg.cnfg_pid_controller(count).A = A;
% cnfg.cnfg_pid_controller(count).B = B;
% cnfg.cnfg_pid_controller(count).cT = cT;
% cnfg.cnfg_pid_controller(count).d = d;
% cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
% cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
% cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
% cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m
% 
% count = count + 1;
% cnfg.cnfg_pid_controller(count).name = 'Test-Regler y poly2';
% cnfg.cnfg_pid_controller(count).position = 250e-3;
% cnfg.cnfg_pid_controller(count).direction = 'u_y';
% cnfg.cnfg_pid_controller(count).type = 'pidControllerPolynomial2';
% cnfg.cnfg_pid_controller(count).A = A;
% cnfg.cnfg_pid_controller(count).B = B;
% cnfg.cnfg_pid_controller(count).cT = cT;
% cnfg.cnfg_pid_controller(count).d = d;
% cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
% cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
% cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
% cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m


%% Look Up Table
count = count + 1;
cnfg.cnfg_pid_controller(count).name = 'Test-Regler x LUT';
cnfg.cnfg_pid_controller(count).position = 250e-3;
cnfg.cnfg_pid_controller(count).direction = 'u_x';
cnfg.cnfg_pid_controller(count).type = 'pidControllerLUT';
cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m
cnfg.cnfg_pid_controller(count).table = load('Inputfiles/pidTestLUT.mat'); 
% zu ladende Datei muss folgende Variablen enthalten (siehe auch Beispiel):
% displacement = 1 x Ndisplacment array
% current = 1 x Ncurrent array
% force = Ncurrent x Ndisplacement

count = count + 1;
cnfg.cnfg_pid_controller(count).name = 'Test-Regler y LUT';
cnfg.cnfg_pid_controller(count).position = 250e-3;
cnfg.cnfg_pid_controller(count).direction = 'u_y';
cnfg.cnfg_pid_controller(count).type = 'pidControllerLUT';
cnfg.cnfg_pid_controller(count).targetDisplacement = 0; % m
cnfg.cnfg_pid_controller(count).electricalP = electricalP; % A/m
cnfg.cnfg_pid_controller(count).electricalI = electricalI; % A/(ms)
cnfg.cnfg_pid_controller(count).electricalD = electricalD; % As/m
cnfg.cnfg_pid_controller(count).table = load('Inputfiles/pidTestLUT.mat'); 
% zu ladende Datei muss folgende Variablen enthalten (siehe auch Beispiel):
% displacement = 1 x Ndisplacment array
% current = 1 x Ncurrent array
% force = Ncurrent x Ndisplacement


%% ======================Active Magnetic Bearing========================
cnfg.cnfg_activeMagneticBearing = [];
count = 0;
