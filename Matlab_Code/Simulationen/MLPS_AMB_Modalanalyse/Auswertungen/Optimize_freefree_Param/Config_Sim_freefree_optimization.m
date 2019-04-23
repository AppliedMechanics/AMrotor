% fuer Optimierung der fehlenden Parameterwerte
% raS, raL, discS.m, discS.Jx, discS.Jz, discML.m, discML.Jx, discML.Jz

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
% raL = 0.04
% riL = sqrt(raL^2-0.940/7446/pi/0.038)
% raR = 0.09
% riR = sqrt(raR^2-1.235/7446/pi/0.011)
% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.091 0.004 0], ... % Welle
%     [0.091 0.04 0.01], [0.129 0.04 0.01], [0.129 0.004 0], ... % Lagerhuelse 1
%     [0.3495 0.004 0], [0.3495 0.09 0.06], [0.3605 0.09 0.06], [0.3605 0.004 0],... % Rotorscheibe
%     [0.611 0.004 0], [0.611 0.04 0.01], [0.649 0.04 0.01], ... % Lagerhuelse 2
%     [0.649 0.004 0], [0.695 0.004 0], [0.695 0 0]}; % Welle

% nur Welle, Komponenten als disc-Objekte
raW = 0.004;
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW 0], [0.702 raW 0]};

% Welle mit Versteifung bei Lagerzapfen
raW = 0.004;
riW = 0;
% raL = raW*1.2
riL = 0;
% raR = raW*1.2
riR = 0;
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 raW riW], [0.094 raW riW], ... % Welle
    [0.094 raL riL], [0.132 raL riL], [0.132 raW riW], ... % Lagerhuelse 1
    [0.350 raW riW], [0.350 raR riR], [0.376 raR riR], [0.376 raW riW],... % Rotorscheibe, Abschnitt E,F,E
    [0.604 raW riW], [0.604 raL riL], [0.642 raL riL], ... % Lagerhuelse 2
    [0.642 raW riW], [0.702 raW riW], [0.702 0 0]}; % Welle


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
count =0;

count = count+1;
cnfg.cnfg_disc(count).name = 'ML_Lauefer_L'; % inkl. Spannhuelsen
cnfg.cnfg_disc(count).position = 113e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 46e-3;  
cnfg.cnfg_disc(count).m = discML.m;                       %disc mass [kg]
cnfg.cnfg_disc(count).Jx = discML.Jx;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = discML.Jz;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;     %disc polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_disc(count).name = 'Massescheibe'; % inkl. Spannhuelsen+Fanglagerhuelsen+SChrauben+Muttern
cnfg.cnfg_disc(count).position = 363e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 96e-3;  
cnfg.cnfg_disc(count).m = discS.m;                    %disc mass [kg]
cnfg.cnfg_disc(count).Jx = discS.Jx;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = discS.Jz;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;     %disc polar mom. of inertia [kg*m^2]

count = count+1;
cnfg.cnfg_disc(count).name = 'ML_Lauefer_R'; % inkl. Spannhuelsen
cnfg.cnfg_disc(count).position = 623e-3;                 %disc position [m]
cnfg.cnfg_disc(count).radius = 46e-3;  
cnfg.cnfg_disc(count).m = discML.m;                       %disc mass [kg]
cnfg.cnfg_disc(count).Jx = discML.Jx;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = discML.Jz;                  %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;     %disc polar mom. of inertia [kg*m^2]

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0; 

% Sensoren fuer eingebauten Rotor in MLPS
% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'EddyL1';
% cnfg.cnfg_sensor(count).position=0.071;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'WegMLL';
% cnfg.cnfg_sensor(count).position=0.113;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'EddyL2';
% cnfg.cnfg_sensor(count).position=0.155;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Laser';
% cnfg.cnfg_sensor(count).position=0.363;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'EddyR1';
% cnfg.cnfg_sensor(count).position=0.581;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='WegMLR';
% cnfg.cnfg_sensor(count).position=0.623;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name = 'EddyR2';
% cnfg.cnfg_sensor(count).position=0.665;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftMLL';
% cnfg.cnfg_sensor(count).position=0.113;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftLaser';
% cnfg.cnfg_sensor(count).position=0.363;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='KraftMLR';
% cnfg.cnfg_sensor(count).position=0.623;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

%% sensoren fuer free-free-MAC
cnfg.cnfg_sensor=[];
count = 0; 
SensPos = [51,76,151,190,307,414,568,594,675,692]*1e-3

for count = 1:length(SensPos)
cnfg.cnfg_sensor(count).name = ['Weg',num2str(count)];
cnfg.cnfg_sensor(count).position=SensPos(count);
cnfg.cnfg_sensor(count).type='Displacementsensor';
end


%% ========================================================================
% % Lager
cnfg.cnfg_bearing=[];
count = 0;

% count = 1;
% cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_bearing(count).position=113e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;%299.275;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_bearing(count).position=623e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;%299.275;

%fuer free-free-Test:
count = count+1;
cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=113e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=623e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
cnfg.cnfg_bearing(count).damping =0;

% count = count+1;
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';%'RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% 
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=10e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;

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