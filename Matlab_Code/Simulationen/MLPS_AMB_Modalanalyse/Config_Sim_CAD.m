%% ======================================================================
% Abgestimmt mit Daten aus dem CAD, siehe Masterarbeit Ausarbeitung

% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
% cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
% cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0;%6.1090e-06;%0.1*2.6763e-07;%6.1090e-05;%3.5834e-07;%0;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0;%0.14707;%0.1*1.8334;%1.4707;%30;%1e7;%0.001;

% Rotor Config
% Geometrie wie in der Masterarbeit tab:MLPSGeometrie
% Abschnitte A,B,C,D,E,F als 1,2,3,4,5,6
A = [4.70228E-05, 0.000386307, 0.002318817, 0.000412598, 0.002858119, 0.014949];
I = [1.76117E-10, 1.22902E-07, 4.71982E-07, 6.92336E-08, 3.26612E-06, 1.84085E-05];
[ra,ri] = calculate_radii_from_IA(A,I);
z = [0, 64, 94, 132, 162, 335, 350, 360, 366, 376, 391, 574, 604, 642, 672, 702]*1e-3;%Geometrieknoten z-Positionen

cnfg.cnfg_rotor.geo_nodes = {[z(1) ra(1) ri(1)], [z(2) ra(1) ri(1)], ... % Abschnitt A
    [z(2) ra(2) ri(2)], [z(3) ra(2) ri(2)], ... % Abschnitt B
    [z(3) ra(3) ri(3)], [z(4) ra(3) ri(3)], ... % Abschnitt C
    [z(4) ra(2) ri(2)], [z(5) ra(2) ri(2)], ... % Abschnitt B
    [z(5) ra(1) ri(1)], [z(6) ra(1) ri(1)], ... % Abschnitt A
    [z(6) ra(4) ri(4)], [z(7) ra(4) ri(4)], ... % Abschnitt D
    [z(7) ra(5) ri(5)], [z(8) ra(5) ri(5)], ... % Abschnitt E
    [z(8) ra(6) ri(6)], [z(9) ra(6) ri(6)], ... % Abschnitt F
    [z(9) ra(5) ri(5)], [z(10) ra(5) ri(5)], ... % Abschnitt E
    [z(10) ra(4) ri(4)], [z(11) ra(4) ri(4)], ... % Abschnitt D
    [z(11) ra(1) ri(1)], [z(12) ra(1) ri(1)], ... % Abschnitt A
    [z(12) ra(2) ri(2)], [z(13) ra(2) ri(2)], ... % Abschnitt B
    [z(13) ra(3) ri(3)], [z(14) ra(3) ri(3)], ... % Abschnitt C
    [z(14) ra(2) ri(2)], [z(15) ra(2) ri(2)], ... % Abschnitt B
    [z(15) ra(1) ri(1)], [z(16) ra(1) ri(1)], ... % Abschnitt A
    }; % Endknoten
clear A I ra ri z


% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.005; % sehr kleiner Wert, damit auch der kleinste Abschnitt noch abgebildet wird
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
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  
% 
% count = count+1;
% cnfg.cnfg_disc(count).name = 'Lagerhuelse2';
% cnfg.cnfg_disc(count).position = 590e-3;                 %disc position [m]
% cnfg.cnfg_disc(count).radius = 32.5e-3;  
% cnfg.cnfg_disc(count).m = 0.1784;                             %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  
% 
% count = count+1;
% cnfg.cnfg_disc(count).name = 'Scheibe';
% cnfg.cnfg_disc(count).position = 350e-3;                 %disc position [m]
% cnfg.cnfg_disc(count).radius = 69e-3;  
% cnfg.cnfg_disc(count).m = 0.8041;                             %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = 0;%1e-4;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jz = 0;%1e-4;                          %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jp = 0;%1/2*1e-4;  

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];
count = 0; 

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL1';
cnfg.cnfg_sensor(count).position=0.071;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'WegMLL';
cnfg.cnfg_sensor(count).position=0.113;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyL2';
cnfg.cnfg_sensor(count).position=0.155;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Laser';
cnfg.cnfg_sensor(count).position=0.363;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR1';
cnfg.cnfg_sensor(count).position=0.581;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='WegMLR';
cnfg.cnfg_sensor(count).position=0.623;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name = 'EddyR2';
cnfg.cnfg_sensor(count).position=0.665;
cnfg.cnfg_sensor(count).type='Displacementsensor';


count = count + 1;
cnfg.cnfg_sensor(count).name='KraftMLL';
cnfg.cnfg_sensor(count).position=0.113;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftLaser';
cnfg.cnfg_sensor(count).position=0.363;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='KraftMLR';
cnfg.cnfg_sensor(count).position=0.623;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

%% sensoren fuer free-free-MAC
% cnfg.cnfg_sensor=[];
% count = 0; 
% SensPos = []*1e-2
% 
% for count = 1:length(SensPos)
% cnfg.cnfg_sensor(count).name = ['Weg',num2str(count)];
% cnfg.cnfg_sensor(count).position=SensPos(count);
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% end


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
cnfg.cnfg_bearing(count).position=113e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;%299.275;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=623e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7*0.5;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;%299.275;

% % fuer free-free-Test
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
% cnfg.cnfg_bearing(count).position=110e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;
% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
% cnfg.cnfg_bearing(count).position=590e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleBearing';
% cnfg.cnfg_bearing(count).stiffness=1;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 0;

%% ========================================================================
cnfg.cnfg_load=[];
count = 0;

% % Kraft in feste Richtung
% count = count + 1;
% cnfg.cnfg_load(count).name='Const. Kraft';
% cnfg.cnfg_load(count).position=350e-3;
% cnfg.cnfg_load(count).betrag_x= 1;
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

% % Chirp, Sinus-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Chirp Kraft';
% cnfg.cnfg_load(count).position= 110e-3; %590e-3;% Position ML 2
% cnfg.cnfg_load(count).betrag_x= 1e-2;
% cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency_x= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).betrag_y= 0;%0.5e-2;
% cnfg.cnfg_load(count).frequency_y_0 = 0;
% cnfg.cnfg_load(count).frequency_y= 0;
% cnfg.cnfg_load(count).t_end= 3; % Zeitdauer des Chirps, hier wird f erreicht
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
cnfg.cnfg_load(count).position=0.110;%PosML1    
% t = 0:1e-3:1;
% cnfg.cnfg_load(count).Table.time = t;
% cnfg.cnfg_load(count).Table.force{1} = 1e-2*sin(2*pi*30*t); %Fx [N]
% cnfg.cnfg_load(count).Table.force{2} = zeros(size(t)); %Fy [N]
% cnfg.cnfg_load(count).Table.force{3} = zeros(size(t)); %Fz [N]
% cnfg.cnfg_load(count).Table.force{4} = zeros(size(t)); %Mx [N]
% cnfg.cnfg_load(count).Table.force{5} = zeros(size(t)); %My [N]
% cnfg.cnfg_load(count).Table.force{6} = zeros(size(t)); %Mz [N]
% cnfg.cnfg_load(count).Table.time = load_force_table('Inputfiles/noise250Hz.mat'); 
load('Inputfiles/noise250Hz_1kHz.mat')
cnfg.cnfg_load(count).Table.time = t;
cnfg.cnfg_load(count).Table.force{1} = 1e-3*x; %Fx [N]
cnfg.cnfg_load(count).Table.force{2} = 0*x; %Fy [N]
cnfg.cnfg_load(count).Table.force{3} = 0*x; %Fz [N]
cnfg.cnfg_load(count).Table.force{4} = 0*x; %Mx [N]
cnfg.cnfg_load(count).Table.force{5} = 0*x; %My [N]
cnfg.cnfg_load(count).Table.force{6} = 0*x; %Mz [N]
cnfg.cnfg_load(count).type='Force_timevariant_look_up';
clear t x

count = count+1;
cnfg.cnfg_load(count).name='Noise2';
cnfg.cnfg_load(count).position=0.590; % Position ML 2
load('Inputfiles/noise250Hz_b.mat')
cnfg.cnfg_load(count).Table.time = t;
cnfg.cnfg_load(count).Table.force{1} = 1e-3*x; %Fx [N]
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