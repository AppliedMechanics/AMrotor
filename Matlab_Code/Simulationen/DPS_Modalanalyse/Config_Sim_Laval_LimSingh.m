%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Symmetrischer Laval-Rotor mit dynamischem Lim Singh Lagermodell';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.shear_factor = 0.9;
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0.001;

% Rotor Config
% r_Welle = 10e-3; % Radius der Welle
% r_Laeufer = 80e-3; 
% cnfg.cnfg_rotor.geo_nodes = {[0 r_Welle 0], [0.270 r_Welle 0], ...
%     [0.270 r_Laeufer 0], [0.330 r_Laeufer 0], [0.330 r_Welle 0],...
%     [0.600 r_Welle 0],}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten
% clear r_Welle r_Laeufer_D r_Laeufer_ML r_Laeufer_D_innen r_Laeufer_ML_innen

% cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.250 0.004 0], [0.250 0.069 0], [0.350 0.069 0], [0.350 0.004 0], [0.600 0.004 0], [0.600 0 0]};
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.01 0], [0.290 0.01 0], [0.290 0.069 0], [0.310 0.069 0], [0.310 0.01 0], [0.600 0.01 0], [0.600 0 0]};

% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.004;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean.
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
cnfg.cnfg_rotor.mesh_opt.d_min= 0.02;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean.
    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];

cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
cnfg.cnfg_disc(1).position = 300e-3;                 %disc position [m]
cnfg.cnfg_disc(1).radius = 200e-3;                   %only for plot
cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
cnfg.cnfg_disc(1).Jx = 1;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(1).Jz = 1;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(1).Jp = 1e-1;                         %disc polar mom. of inertia [kg*m^2] (polar)

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0;

% count = count+1;
% cnfg.cnfg_sensor(count).name = 'Wirbelstrom Lager1';
% cnfg.cnfg_sensor(count).position=0e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 1';
% cnfg.cnfg_sensor(count).position=227.5e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom aussermittig';
cnfg.cnfg_sensor(count).position=400e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung Mitte';
cnfg.cnfg_sensor(count).position=300e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 2';
% cnfg.cnfg_sensor(count).position=332.5e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
% cnfg.cnfg_sensor(count).position=600e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];
count = 0;
% 
% count = count +1 ;
% cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Torque Lager Links'; % Torque Lager koppelt die Torsion an die Umgebung und verhindert so die Starrkoerpermode fuer den Torsionsfreiheitsgrad psi_z.
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_bearing(count).position=50e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=550e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 3';
% cnfg.cnfg_bearing(count).position=300e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Kennfeld Lager';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='LookUpTableBearing';
% cnfg.cnfg_bearing(count).Table = load_bearing('01_bearingTPFax100LS.mat'); 
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Kennfeld Lager';
% cnfg.cnfg_bearing(count).position=600e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='LookUpTableBearing';
% cnfg.cnfg_bearing(count).Table = load_bearing('01_bearingTPFax100LS.mat');   

% count = count+1;
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% 
% count = count+1;
% cnfg.cnfg_bearing(count).name = 'Feste Einspannung';
% cnfg.cnfg_bearing(count).position=600e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='RestrictAllDofsBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;

%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% % Kraft in feste Richtung % macht Berechnung langsam
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft';
% cnfg.cnfg_load(count).position=150e-3;
% cnfg.cnfg_load(count).betrag_x= 0;
% cnfg.cnfg_load(count).betrag_y= -100;
% cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
count = count + 1;
cnfg.cnfg_load(count).name = 'Kleine Unwucht';
cnfg.cnfg_load(count).position = 150e-3;
cnfg.cnfg_load(count).betrag = 1e-2;%5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

% % Sinusfoermige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 100;
% cnfg.cnfg_load(count).frequency_x= 40;  %in Hz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% % Whirl, Anregungskraft beschreibt Ellipse
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 200;  %in Hz
% cnfg.cnfg_load(count).type='Force_timevariant_whirl';

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
% cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_end= 1000;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_sweep';

% Lim-Singh-bearing als load fuer Time-Integration
count = count + 1;
cnfg.cnfg_load(count).name = 'LimSingh Rillenkugellager 1';
cnfg.cnfg_load(count).position=50e-3;                        %[m]
cnfg.cnfg_load(count).type='LimSinghBearing';
cnfg.cnfg_load(count).par = load_bearing_LimSingh('parametersGupta20mm.m'); 

% % Lim-Singh-bearing als load fuer Time-Integration
% count = count + 1;
% cnfg.cnfg_load(count).name = 'LimSingh Rillenkugellager 2';
% cnfg.cnfg_load(count).position=600e-3;                        %[m]
% cnfg.cnfg_load(count).type='LimSinghBearing';
% cnfg.cnfg_load(count).par = load_bearing_LimSingh('parametersGupta20mm.m'); 

% seals als loads dazu

%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];

% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Black';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='BlackSeal';
% cnfg.cnfg_seal(count).sealModel = load_seal_model;
% 
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Childs';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='ChildsSeal';
% cnfg.cnfg_seal(count).sealModel = load_seal_model;

% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel = load_seal_table('Koeffizienten_Volumenstrom_2bar.mat'); 
