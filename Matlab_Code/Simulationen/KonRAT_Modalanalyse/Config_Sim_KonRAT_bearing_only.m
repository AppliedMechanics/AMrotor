%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

pos.bearing(1) = 65.182e-3;
pos.bearing(2) = 212e-3;
pos.inducer = 3.045e-3;
pos.impeller = 47.541e-3;
pos.turbine = 250.007e-3;
pos.seal(1) = 42.3e-3;
pos.seal(2) = 52.682e-3;
pos.seal(3) = 138.591e-3;
pos.seal(4) = 242.25e-3;

cnfg.cnfg_rotor.name = 'KonRAT Turbopumpe mit 5 aufgesetzten Scheiben und 2 Lagern, noch ohne Dichtungen';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

% Rotor Config
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 13 0], [30 13 0], [30 14 0], [55.182 14 0], [55.182 15 0], [220 15 0], [220 18 0], [260 18 0]};
cnfg.cnfg_rotor.geo_nodes = cellfun(@(x) x*1e-3,cnfg.cnfg_rotor.geo_nodes,'UniformOutput',false); % Umrechung von mm in m
clear delta

% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.004;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
% cnfg.cnfg_rotor.mesh_opt.d_min= 0.02;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean.
    
%% ========================================================================
% Massescheiben
% Jede SCheibe stellt im ersten Schritt ein Bauteil dar, dass auf der Welle
% befestigt ist. Die Daten wurden mithilfe von Catia aus dem 3D-Modell
% ausgelesen.
cnfg.cnfg_disc=[];
count = 0;

count = count + 1;
cnfg.cnfg_disc(count).name = 'Inducer';
cnfg.cnfg_disc(count).position = pos.inducer;                  %disc position [m]
cnfg.cnfg_disc(count).radius = 20e-3;                       %only for plot
cnfg.cnfg_disc(count).m = 0.4486;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 1.9757e-4;                       %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = 1.4768e-4;                        %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = 2*cnfg.cnfg_disc(1).Jz;          %disc polar mom. of inertia [kg*m^2] (polar) % Annahme: wie Kreisring

count = count + 1;
cnfg.cnfg_disc(count).name = 'Impeller';
cnfg.cnfg_disc(count).position = pos.impeller;                  %disc position [m]
cnfg.cnfg_disc(count).radius = 48e-3;                       %only for plot
cnfg.cnfg_disc(count).m = 1.056;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 5.905e-4;                       %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = 0.001089;                        %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = 2*cnfg.cnfg_disc(1).Jz;          %disc polar mom. of inertia [kg*m^2] (polar) % Annahme: wie Kreisring

count = count + 1;
cnfg.cnfg_disc(count).name = 'Bearing 1 inner ring';
cnfg.cnfg_disc(count).position = pos.bearing(1);                  %disc position [m]
cnfg.cnfg_disc(count).radius = 31e-3;                       %only for plot
cnfg.cnfg_disc(count).m = 0.0658;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 0.00012;                       %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = 0.000021;                        %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = 2*cnfg.cnfg_disc(1).Jz;          %disc polar mom. of inertia [kg*m^2] (polar) % Annahme: wie Kreisring

count = count + 1;
cnfg.cnfg_disc(count).name = 'Bearing 2 inner ring';
cnfg.cnfg_disc(count).position = pos.bearing(2);                  %disc position [m]
cnfg.cnfg_disc(count).radius = 31e-3;                       %only for plot
cnfg.cnfg_disc(count).m = 0.0658;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 0.00012;                       %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = 0.000021;                        %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = 2*cnfg.cnfg_disc(1).Jz;          %disc polar mom. of inertia [kg*m^2] (polar) % Annahme: wie Kreisring

count = count + 1;
cnfg.cnfg_disc(count).name = 'Turbine';
cnfg.cnfg_disc(count).position = pos.turbine;                  %disc position [m]
cnfg.cnfg_disc(count).radius = 98e-3;                       %only for plot
cnfg.cnfg_disc(count).m = 1.765433;                             %disc mass [kg]
cnfg.cnfg_disc(count).Jx = 0.004128;                       %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = 0.008227;                        %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = 2*cnfg.cnfg_disc(1).Jz;          %disc polar mom. of inertia [kg*m^2] (polar) % Annahme: wie Kreisring


%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0;

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Inducer';
cnfg.cnfg_sensor(count).position=pos.inducer;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Impeller';
cnfg.cnfg_sensor(count).position=pos.impeller;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'Wirbelstrom Lager1';
cnfg.cnfg_sensor(count).position=pos.bearing(1);
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
cnfg.cnfg_sensor(count).position=pos.bearing(2);
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Turbine';
cnfg.cnfg_sensor(count).position=pos.turbine;
cnfg.cnfg_sensor(count).type='Displacementsensor';

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
cnfg.cnfg_bearing(count).name = 'Torque Lager Links'; % Torque Lager koppelt die Torsion an die Umgebung und verhindert so die Starrkoerpermode fuer den Torsionsfreiheitsgrad psi_z.
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 100;

strFileName = './Inputfiles/bearingTPFax10000LS.mat'
% strFileName = './Inputfiles/bearingTPFax10000Full.mat'
count = count + 1;
cnfg.cnfg_bearing(count).name = 'Kennfeld Rillenkugellager 1';
cnfg.cnfg_bearing(count).position=pos.bearing(1);                        %[m]
cnfg.cnfg_bearing(count).type='LookUpTableBearing';
cnfg.cnfg_bearing(count).Table = load_bearing(strFileName); 

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Kennfeld Rillenkugellager 2';
cnfg.cnfg_bearing(count).position=pos.bearing(2);                        %[m]
cnfg.cnfg_bearing(count).type='LookUpTableBearing';
cnfg.cnfg_bearing(count).Table = load_bearing(strFileName); 

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_bearing(count).position=pos.bearing(1);                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_bearing(count).position=pos.bearing(2);                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
% cnfg.cnfg_bearing(count).damping = 299.275; % ???

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
% count = count + 1;
% cnfg.cnfg_load(count).name = 'Kleine Unwucht';
% cnfg.cnfg_load(count).position = 300e-3;
% cnfg.cnfg_load(count).betrag = 1e-6;%5e-6;
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusfoermige Anregungskraft
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
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=138e-3; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 1;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 1000;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_end= 0.6;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';

%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];
 
% Define Seals
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Black';
% cnfg.cnfg_seal(count).position=100e-3;                        %[m]
% cnfg.cnfg_seal(count).type='BlackSeal';
% cnfg.cnfg_seal(count).sealModel = load_seal_model;

% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Childs';
% cnfg.cnfg_seal(count).position=150e-3;                        %[m]
% cnfg.cnfg_seal(count).type='ChildsSeal';
% cnfg.cnfg_seal(count).sealModel = load_seal_model;
% 
% count = count+1;
% strSeal1 = './Inputfiles/TPKonRATEcc0Seal1.mat'
% cnfg.cnfg_seal(count).name = 'Inlet Seal';
% cnfg.cnfg_seal(count).position=pos.seal(1);                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(strSeal1); 
% 
% count = count+1;
% strSeal2 = './Inputfiles/TPKonRATEcc0Seal2.mat'
% cnfg.cnfg_seal(count).name = 'Discharge Seal';
% cnfg.cnfg_seal(count).position=pos.seal(2);                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(strSeal2); 
% 
% count = count+1;
% strSeal3 = './Inputfiles/TPKonRATEcc0Seal3.mat'
% cnfg.cnfg_seal(count).name = 'Inter stage seal';
% cnfg.cnfg_seal(count).position=pos.seal(3);                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(strSeal3); 
% 
% count = count+1;
% strSeal4 = './Inputfiles/TPKonRATEcc0Seal4.mat'
% cnfg.cnfg_seal(count).name = 'Turbine Seal';
% cnfg.cnfg_seal(count).position=pos.seal(4);                        %[m]
% cnfg.cnfg_seal(count).type='LookUpTableSeal';
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(strSeal4); 
