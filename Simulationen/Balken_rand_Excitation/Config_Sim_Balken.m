%% ================Rotor===================================================
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Einfacher Balken';
cnfg.cnfg_rotor.color='magenta';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1e-5;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 10;%0.001;

% Rotor Config
beamLength = 0.5; %0.5 Meter
radius = 4e-3; 
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 radius 0], [beamLength radius 0]};

% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
cnfg.cnfg_rotor.mesh_opt.name = 'grobes Netz';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10;
cnfg.cnfg_rotor.mesh_opt.d_min= 0.02;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';
    
%% =========================Komponenten====================================
count = 0;
cnfg.cnfg_component = []; 
% 
% count = count +1;
% cnfg.cnfg_component(count).name = 'Regularisierung der Steifigkeit';
% cnfg.cnfg_component(count).type='Bearings';
% cnfg.cnfg_component(count).subtype='RestrictAllDofsBearing';
% cnfg.cnfg_component(count).position=0e-3;                        %[m]
% cnfg.cnfg_component(count).stiffness= 1;                     %[N/m]
% cnfg.cnfg_component(count).damping = 0;
% cnfg.cnfg_component(count).color = [];
% cnfg.cnfg_component(count).width = 20e-3;

count = count +1;
cnfg.cnfg_component(count).name = 'Feste Einspannung';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='RestrictAllDofsBearing';
cnfg.cnfg_component(count).position=0e-3;                        %[m]
cnfg.cnfg_component(count).stiffness= 1e8;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;
cnfg.cnfg_component(count).color = [];
cnfg.cnfg_component(count).width = 20e-3;


% Feder auf der rechten Seite
count = count + 1;
cnfg.cnfg_component(count).name = 'Feder am Ende';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=beamLength;                        %[m]
cnfg.cnfg_component(count).stiffness=1e5; %[N/m]
cnfg.cnfg_component(count).damping = 0; 
cnfg.cnfg_component(count).color = [];
cnfg.cnfg_component(count).width = 20e-3;

%% ====================Sensoren============================================
cnfg.cnfg_sensor=[];
count = 0;

count = count + 1;
cnfg.cnfg_sensor(count).name='Beschleunigung_Mitte';
cnfg.cnfg_sensor(count).position=beamLength/2;
cnfg.cnfg_sensor(count).type='Accelerationsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_Ende_Anregung';
cnfg.cnfg_sensor(count).position=beamLength;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Beschleunigung_Ende';
cnfg.cnfg_sensor(count).position=beamLength;
cnfg.cnfg_sensor(count).type='Accelerationsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_Ende';
cnfg.cnfg_sensor(count).position=beamLength;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_Lager_Ende';
cnfg.cnfg_sensor(count).position=beamLength;
cnfg.cnfg_sensor(count).type='BearingForceSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_fast_Ende';
cnfg.cnfg_sensor(count).position=0.47;
cnfg.cnfg_sensor(count).type='Displacementsensor';


%% =========================Lasten=========================================
cnfg.cnfg_load=[];
count = 0;

% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=beamLength; % am Ende des Balkens
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 300;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 0;
% cnfg.cnfg_load(count).t_end= 2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=beamLength/2; % mittig auf Balken
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 300;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 0.5;
% cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';
% 
% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=beamLength/2; % mittig auf Balken
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 300;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 1;
% cnfg.cnfg_load(count).t_end= 1.5; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';
% 
% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=beamLength/2; % mittig auf Balken
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 300;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_start= 1.5;
% cnfg.cnfg_load(count).t_end= 2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% Look Up table Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Random Kraft MLL';
cnfg.cnfg_load(count).position=beamLength; 
cnfg.cnfg_load(count).LUT.time = 0:1e-3:5;
cnfg.cnfg_load(count).LUT.Fx = rand(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fy = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Fz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mx = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.My = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).LUT.Mz = zeros(length(cnfg.cnfg_load(count).LUT.time),1);
cnfg.cnfg_load(count).type='Force_timevariant_LUT';

%% ========================PID-Regler======================================
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing========================
cnfg.cnfg_activeMagneticBearing = [];
count = 0;