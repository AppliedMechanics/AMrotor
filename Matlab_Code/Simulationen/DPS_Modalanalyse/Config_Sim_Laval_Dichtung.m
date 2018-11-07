%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'Symmetrischer Laval-Rotor mit mittiger Dichtung';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.shear_factor = 0.9;
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.001;

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
cnfg.cnfg_disc=[];

% cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
% cnfg.cnfg_disc(1).position = 300e-3;                 %disc position [m]
% cnfg.cnfg_disc(1).radius = 200e-3;                   %only for plot
% cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
% cnfg.cnfg_disc(1).Jx = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jz = 1;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(1).Jp = 1e-1;                         %disc polar mom. of inertia [kg*m^2] (polar)

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'Wirbelstrom Lager1';
cnfg.cnfg_sensor(count).position=0e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 1';
% cnfg.cnfg_sensor(count).position=227.5e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung Mitte';
cnfg.cnfg_sensor(count).position=300e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 2';
% cnfg.cnfg_sensor(count).position=332.5e-3;
% cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
cnfg.cnfg_sensor(count).position=600e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

%% ========================================================================
% Lager
cnfg.cnfg_lager=[];

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

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=600e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=1e8;%0.0670680e7; % ???                    %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275; % ???

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Kennfeld Lager';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='LookUpTableBearing';
% load_bearing1
% cnfg.cnfg_bearing(count).Table.stiffness_matrix = K_bearing; % [N/m]
% %dof: [u_x, u_y, u_z, psi_x, psi_y]',
% cnfg.cnfg_bearing(count).Table.damping_matrix = C_bearing;
% cnfg.cnfg_bearing(count).Table.rpm = rpm;
% 
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Kennfeld Lager';
% cnfg.cnfg_bearing(count).position=600e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='LookUpTableBearing';
% load_bearing1
% cnfg.cnfg_bearing(count).Table.stiffness_matrix = K_bearing; % [N/m]
% %dof: [u_x, u_y, u_z, psi_x, psi_y]',
% cnfg.cnfg_bearing(count).Table.damping_matrix = C_bearing;
% cnfg.cnfg_bearing(count).Table.rpm = rpm;
%    
% clear K_bearing C_bearing rpm


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
cnfg.cnfg_load(count).position = 300e-3;
cnfg.cnfg_load(count).betrag = 1e-6;%5e-6;
cnfg.cnfg_load(count).winkellage = 0;
cnfg.cnfg_load(count).type='Unbalance_static';

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
cnfg.cnfg_load(count).type='Force_timevariant_whirl_sweep';

%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];
% Seal-Coefficients for Childs/Black-Modell
tempSeal.T=42.5;
tempSeal.nu40=46;
tempSeal.nu100=7;
tempSeal.nut=tempSeal.nu40+((tempSeal.nu40-tempSeal.nu100)/(40-100))*(tempSeal.T-40);
% sealModel.type = 'Black'; % nur 'Black', 'Childs', 'Table' zulaessig
sealModel.sys.v0 = 0;%-0.5;                      
sealModel.sys.d = 0.1-2*0.00017;                       % Innendurchmesser
sealModel.sys.D = 0.1; %sys.d + 2 * 0.1397e-3;          % Auszendurchmesser
sealModel.sys.L = 0.02;                       % Spaltlaenge
sealModel.sys.R = (0.5*sealModel.sys.D+0.5*sealModel.sys.d)*0.5;  % Mittlerer Radius
sealModel.sys.Dpw = 0.5*(sealModel.sys.D+sealModel.sys.d);        % Mittlerer Durchmesser
sealModel.sys.S = 0.5*sealModel.sys.D-0.5*sealModel.sys.d;        % Spaltweite
sealModel.sys.xi_ein = 0.1;                   % Eintrittsverlust im Dichtspalt
sealModel.sys.xi_aus = 1;                     % Austrittsverlust im Dichtspalt
sealModel.sys.p = 3e5;                     % Druckdifferenz ueber Dichtung in Pa, N/m^2, 1bar=10^5Pa
sealModel.sys.rho = 880;                      % Dichte
sealModel.sys.nu = tempSeal.nut*sealModel.sys.rho*10^(-6);   

% Load Look up table for 'Table'
load('Koeffizienten_Volumenstrom_2bar.mat')
sealModel.Table.rpm = wellendrehzahl;
sealModel.Table.m_xx = masse;
sealModel.Table.d_xx = hauptdaempfung;
sealModel.Table.d_xy = nebendaempfung;
sealModel.Table.k_xx = hauptsteifigkeit;
sealModel.Table.k_xy = nebensteifigkeit;
clear wellendrehzahl masse hauptdaempfung nebendaempfung hauptsteifigkeit nebensteifigkeit
 
% Define Seals
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Black';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='SimpleSeal';
% cnfg.cnfg_seal(count).sealModel = sealModel;
% cnfg.cnfg_seal(count).sealModel.type = 'Black';

% Define Seals
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung Childs';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='SimpleSeal';
% cnfg.cnfg_seal(count).sealModel = sealModel;
% cnfg.cnfg_seal(count).sealModel.type = 'Childs';

% Define Seals
% count = count+1;
% cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
% cnfg.cnfg_seal(count).position=300e-3;                        %[m]
% cnfg.cnfg_seal(count).type='SimpleSeal';
% cnfg.cnfg_seal(count).sealModel = sealModel;
% cnfg.cnfg_seal(count).sealModel.type = 'Table';


clear sealModel tempSeal
