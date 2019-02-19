%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor, symmetrisches Modell';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

% % Rotor Config
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.3495 0.004 0], [0.3495 0.069 0], [0.3605 0.069 0], [0.3605 0.004 0], [0.695 0.004 0], [0.695 0 0]};

% Rotor Config ohne Durchmesserspruenge
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.70 0.004 0], [0.700 0 0]};

% % Rotor Config inkl. Lagerhuelsen
% % Lagerhuelsen
% %   mL = 0.940 kg aus MA Maierhofer
% %   rL = 32.5 mm aus Berechnung mit Masse
% %   lL = 38 mm aus CAD
% %   Lagerhuelse 1: Mittelpunkt bei 110 mm (aus Config_file unten), zleft=91mm, zright=129mm 
% %   Lagerhuelse 2: Mittelpunkt bei 630 mm, zleft=611mm, zright=649mm
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
%     [0.091 0.0325 0], [0.129 0.0325 0], [0.129 0.004 0], ... % Lagerhuelse 1
%     [0.3495 0.004 0], [0.3495 0.069 0], [0.3605 0.069 0], [0.3605 0.004 0],... % Rotorscheibe
%     [0.611 0.004 0], [0.611 0.0325 0], [0.649 0.0325 0], ... % Lagerhuelse 2
%     [0.649 0.004 0], [0.695 0.004 0], [0.695 0 0]}; % Welle


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.

    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];
count = 0;

count = count+1;
cnfg.cnfg_disc(count).name = 'Lagerhuelse1';
cnfg.cnfg_disc(count).position = 110e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 32.5e-3;  
cnfg.cnfg_disc(count).m = 0.940;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 1e-4;                         %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jz = 1e-4;                          %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jp = 1/2*1e-4;  
% E = 2111e9;
% G = 8.1154e+10;
% rho = cnfg.cnfg_rotor.material.density;
% ro = 32.5e-3;
% l = 38e-3;
% m = 0.94;
% ri = sqrt(ro^2  - m/rho/pi/l);
% Iy = pi/4*(ro^4+ri^4);
% Ip = 2*Iy;
% A = pi*(ro^2-ri^2);
% phi = 12*E*Iy/(G*A*l^2*0.9);
% cnfg.cnfg_disc(count).Jx = l^2*(4+7*phi+3.5*l^2);                         %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jz = 2*rho*l/6*Ip;                          %disc mom. of inertia [kg*m^4]
% cnfg.cnfg_disc(count).Jp = 1/2*cnfg.cnfg_disc(count).Jz;                         %disc polar mom. of inertia [kg*m^4]

count = count+1;
cnfg.cnfg_disc(count).name = 'Lagerhuelse2';
cnfg.cnfg_disc(count).position = 590e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 32.5e-3;  
cnfg.cnfg_disc(count).m = 0.940;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 1e-4;                         %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jz = 1e-4;                          %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jp = 1/2*1e-4;                         %disc polar mom. of inertia [kg*m^4]


count = count+1;
cnfg.cnfg_disc(count).name = 'Rotorscheibe';
cnfg.cnfg_disc(count).position = 350e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 69e-3;  
cnfg.cnfg_disc(count).m = 1.235;                             %disc mass [kg]
% ro = 0.1;
% l = 11e-3;
% m = 1.235;
% ri = sqrt(ro^2  - m/rho/pi/l);
% Iy = pi/4*(ro^4+ri^4);
% Ip = 2*Iy;
% A = pi*(ro^2-ri^2);
% phi = 12*E*Iy/(G*A*l^2*0.9);
cnfg.cnfg_disc(count).Jx = 5e-3;                         %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jz = 1e-3;                          %disc mom. of inertia [kg*m^4]
cnfg.cnfg_disc(count).Jp = 1/2*1e-4;                         %disc polar mom. of inertia [kg*m^4]

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'WegLager1';
cnfg.cnfg_sensor(count).position=0.110;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegScheibe';
cnfg.cnfg_sensor(count).position=0.350;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegLager2';
cnfg.cnfg_sensor(count).position=0.590;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftLager1';
cnfg.cnfg_sensor(count).position=0.110;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftScheibe';
cnfg.cnfg_sensor(count).position=0.350;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

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
cnfg.cnfg_bearing(count).stiffness=1e1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;%100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1e1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;%100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=110e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=590e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;


%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft';
% cnfg.cnfg_load(count).position=590e-3;
% cnfg.cnfg_load(count).betrag_x= 1e-5;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
% count = count + 1;
% cnfg.cnfg_load(count).name = 'Kleine Unwucht';
% cnfg.cnfg_load(count).position = 350e-3;
% cnfg.cnfg_load(count).betrag = 1e-6;%5e-6;
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';

% % Sinusf�rmige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=110e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1e-2;
% cnfg.cnfg_load(count).frequency_x= 200;  %in Hz
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
% cnfg.cnfg_load(count).position=590e-3; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 1e-2;
% cnfg.cnfg_load(count).frequency_x_0 = 1; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 0.5; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=590e-3; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 1000;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_end= 0.6;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% Zusammenbauen eines Impulskamms:
% count = count + 1;
% cnfg.cnfg_load(count).name='Impuls1';
% cnfg.cnfg_load(count).position=590e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1e-5;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 0;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= cnfg.cnfg_load(count).t_start+4e-3; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% count = count + 1;
% cnfg.cnfg_load(count).name='Impuls2';
% cnfg.cnfg_load(count).position=590e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1e-5;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 0;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 10e-3; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= cnfg.cnfg_load(count).t_start+4e-3; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% 
% count = count + 1;
% cnfg.cnfg_load(count).name='Impuls3';
% cnfg.cnfg_load(count).position=590e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1e-5;
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 0;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 20e-3; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= cnfg.cnfg_load(count).t_start+4e-3; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

t_start=0e-3;
t_dauer = 100e-3;
while t_start<1000e-3
count = count + 1;
cnfg.cnfg_load(count).name='Sprung';
cnfg.cnfg_load(count).position=590e-3; % Position ML 2
cnfg.cnfg_load(count).betrag_x= 1e-2;
cnfg.cnfg_load(count).betrag_y= 0;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 0;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_start= t_start; %Zeitpkt an dem Startfrequenz anliegt
cnfg.cnfg_load(count).t_end= cnfg.cnfg_load(count).t_start+t_dauer; % Zeitpkt des Ende des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% t_dauer = t_dauer+5e-3;
t_start=t_start+1000e-3;
end

%% ========================================================================
% Dichtungen
cnfg.cnfg_seal = [];