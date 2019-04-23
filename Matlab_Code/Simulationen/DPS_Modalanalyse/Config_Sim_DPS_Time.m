%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'DPS - Rotor fuer Zeitintegration mit Dichtung';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0.001;

% Rotor Config
pos.Lag1 = 9e-3;
pos.ML1 = 138e-3;
pos.Dic1 = 227.5e-3;
pos.DicMitte = 280e-3;
pos.Dic2 = 332.5e-3;
pos.ML2 = 422e-3;
pos.Lag2 = 551e-3;
pos.Mitte = pos.Lag1 + (pos.Lag2-pos.Lag1)/2;
% r_Welle = 7.5e-3; % Radius der Welle
% r_Laeufer_D = 23e-3; %neu 23mm
% r_Laeufer_ML = 23e-3; % Radius Laeufer des Magnetlagers 
% r_Laeufer_D_innen = 11e-3; % Innenradius D Laeufer, sodass I und m wie in Realitaet
% r_Laeufer_ML_innen = 1e-3; % Innenradius ML Laeufer, sodass I und m wie in Realitaet
% cnfg.cnfg_rotor.geo_nodes = {[0 r_Welle 0], [0.118 r_Welle 0], ...
%     [0.118 r_Laeufer_ML r_Laeufer_ML_innen],...
%     [0.158 r_Laeufer_ML r_Laeufer_ML_innen], [0.158 r_Welle 0], ...
%     [0.205 r_Welle 0], [0.205 r_Laeufer_D r_Laeufer_D_innen],...
%     [0.355 r_Laeufer_D r_Laeufer_D_innen], [0.355 r_Welle 0],...
%     [0.402 r_Welle 0], [0.402 r_Laeufer_ML r_Laeufer_ML_innen],...
%     [0.442 r_Laeufer_ML r_Laeufer_ML_innen], [0.442 r_Welle 0],...
%     [0.600 r_Welle 0]}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten
% clear r_Welle r_Laeufer_D r_Laeufer_ML r_Laeufer_D_innen r_Laeufer_ML_innen

% Geometrie wie in der Masterarbeit tab:DPSGeometrie
% Abschnitte A,B,C,D,E,F als 1,2,3,4,5,6
A = [0.000170842, 0.001230754, 0.001631406, 0.001563023, 0.001139769, 0.001208152];
I = [2.32316E-09, 1.21911E-07, 2.13906E-07, 2.0211E-07, 1.76151E-07, 1.87946E-07];
[ra,ri] = calculate_radii_from_IA(A,I);

cnfg.cnfg_rotor.geo_nodes = {[0 ra(2) ri(2)], [.018 ra(2) ri(2)], ... % Abschnitt B
    [.018 ra(1) ri(1)], [.118 ra(1) ri(1)], ... % Abschnitt A
    [.118 ra(3) ri(3)], [.158 ra(3) ri(3)], ... % Abschnitt C
    [.158 ra(3) ri(3)], [.215 ra(1) ri(1)], ... % Abschnitt A
    [.215 ra(4) ri(4)], [.233 ra(4) ri(4)], ... % Abschnitt D
    [.233 ra(5) ri(5)], [.258 ra(5) ri(5)], ... % Abschnitt E
    [.258 ra(6) ri(6)], [.302 ra(6) ri(6)], ... % Abschnitt F
    [.302 ra(5) ri(5)], [.327 ra(5) ri(5)], ... % Abschnitt E
    [.327 ra(4) ri(4)], [.345 ra(4) ri(4)], ... % Abschnitt D
    [.345 ra(1) ri(1)], [.402 ra(1) ri(1)], ... % Abschnitt A
    [.402 ra(3) ri(3)], [.442 ra(3) ri(3)], ... % Abschnitt C
    [.442 ra(1) ri(1)], [.542 ra(1) ri(1)], ... % Abschnitt A
    [.542 ra(2) ri(2)], [.560 ra(2) ri(2)], ... % Abschnitt B
    [.560 ra(1) ri(1)], [.580 ra(1) ri(1)], ... % Abschnitt A
    }; % Endknoten
clear A I ra ri


% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.02;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';
    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];

% cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
% cnfg.cnfg_disc(1).position = 300e-3;                 %disc position [m]
% cnfg.cnfg_disc(1).radius = 200e-3;                   %only for plot
% cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
% cnfg.cnfg_disc(1).Jx = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jz = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jp = 1e-3;                         %disc polar mom. of inertia [kg*m^2] (polar)

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'Weg_Lager1';
cnfg.cnfg_sensor(count).position=pos.Lag1;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_ML1';
cnfg.cnfg_sensor(count).position=pos.ML1;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_Dichtung1';
% cnfg.cnfg_sensor(count).position=pos.Dic1;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_DichtungMitte';
cnfg.cnfg_sensor(count).position=pos.DicMitte;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_Dichtung2';
% cnfg.cnfg_sensor(count).position=pos.Dic2;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_ML2';
cnfg.cnfg_sensor(count).position=pos.ML2;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Weg_Lager2';
cnfg.cnfg_sensor(count).position=pos.Lag2;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_Lager1';
cnfg.cnfg_sensor(count).position=pos.Lag1;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_ML1';
cnfg.cnfg_sensor(count).position=pos.ML1;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_Dichtung1';
% cnfg.cnfg_sensor(count).position=pos.Dic1;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_DichtungMitte';
cnfg.cnfg_sensor(count).position=pos.DicMitte;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_Dichtung2';
% cnfg.cnfg_sensor(count).position=pos.Dic2;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_ML2';
cnfg.cnfg_sensor(count).position=pos.ML2;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_Lager2';
cnfg.cnfg_sensor(count).position=pos.Lag2;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Geschwindigkeit_DichtungMitte';
cnfg.cnfg_sensor(count).position=pos.DicMitte;
cnfg.cnfg_sensor(count).type='Velocitysensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Beschleunigung_DichtungMitte';
cnfg.cnfg_sensor(count).position=pos.DicMitte;
cnfg.cnfg_sensor(count).type='Accelerationsensor';

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];
count = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 100;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Torque Lager Links'; % Was macht das Torque Lager?
% cnfg.cnfg_bearing(count).position=250e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_bearing(count).position=pos.Lag1                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_bearing(count).position=pos.Lag2;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???


%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung
count = count + 1;
cnfg.cnfg_load(count).name='Const. Kraft';
cnfg.cnfg_load(count).position=pos.Mitte;
cnfg.cnfg_load(count).betrag_x= 0;
cnfg.cnfg_load(count).betrag_y= -10;
cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
count = count + 1;
cnfg.cnfg_load(count).name = 'Kleine Unwucht';
cnfg.cnfg_load(count).position = pos.Mitte-30e-3;
cnfg.cnfg_load(count).betrag = 5e-5;%5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

count = count + 1;
cnfg.cnfg_load(count).name = 'Kleine Unwucht';
cnfg.cnfg_load(count).position = pos.Mitte+30e-3;
cnfg.cnfg_load(count).betrag = 5e-5;%5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusfoermige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz
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

% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% fwd-whirl-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Fwd Whirl Sweep Kraft';
cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
cnfg.cnfg_load(count).betrag_x= 10;
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
cnfg.cnfg_load(count).t_end= 0.5; % Zeitpkt des Ende des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% bwd-whirl-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Bwd Whirl Sweep Kraft';
cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
cnfg.cnfg_load(count).betrag_x= 10;
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_start= 0.5;
cnfg.cnfg_load(count).t_end= 1.0;%2; % Zeitdauer des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';

% fwd-whirl-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Fwd Whirl Sweep Kraft';
cnfg.cnfg_load(count).position=pos.ML2; % Position ML 2
cnfg.cnfg_load(count).betrag_x= 10;
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
cnfg.cnfg_load(count).t_end= 0.5; % Zeitpkt des Ende des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

% bwd-whirl-sweep-Kraft
count = count + 1;
cnfg.cnfg_load(count).name='Bwd Whirl Sweep Kraft';
cnfg.cnfg_load(count).position=pos.ML2; % Position ML 2
cnfg.cnfg_load(count).betrag_x= 10;
cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
cnfg.cnfg_load(count).t_start= 0.5;
cnfg.cnfg_load(count).t_end= 1.0;%2; % Zeitdauer des Chirps, hier wird f erreicht
cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';

% Muszynska-Seal laminar
% count = count + 1;
% cnfg.cnfg_load(count).name = 'MuszynskaSealMittig';
% cnfg.cnfg_load(count).position=pos.DicMitte;                        %[m]
% cnfg.cnfg_load(count).type='MuszynskaLaminarSeal';
% cnfg.cnfg_load(count).sealModel = load_seal_model('Inputfiles/TestRigNeu1.m');

% Lim-Singh-bearing
count = count + 1;
cnfg.cnfg_load(count).name = 'LimSingh1';
cnfg.cnfg_load(count).position=pos.Lag1;                        %[m]
cnfg.cnfg_load(count).type='LimSinghBearing';
cnfg.cnfg_load(count).par = load_bearing_LimSingh('Inputfiles/parametersGupta20mm.m'); 

% Lim-Singh-bearing
count = count + 1;
cnfg.cnfg_load(count).name = 'LimSingh2';
cnfg.cnfg_load(count).position=pos.Lag2;                        %[m]
cnfg.cnfg_load(count).type='LimSinghBearing';
cnfg.cnfg_load(count).par = load_bearing_LimSingh('Inputfiles/parametersGupta20mm.m'); 

%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];

count = count+1;
cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
cnfg.cnfg_seal(count).position=300e-3;                        %[m]
cnfg.cnfg_seal(count).type='LookUpTableSeal';
cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigNew1.mat'); 
% 
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/TestRig2.mat'); 
% cnfg.cnfg_seal(count).integrationProblemFlag = false;