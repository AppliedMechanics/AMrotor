%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
% cnfg.cnfg_rotor.material.shear_factor = 0.9; % check Genta p.372, Tiwari p.620
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 0.001;

% Rotor Config
cnfg.cnfg_rotor.geo_nodes = {[0 0 0], [0 0.004 0], [0.3495 0.004 0], [0.3495 0.069 0], [0.3605 0.069 0], [0.3605 0.004 0], [0.695 0.004 0], [0.695 0 0]};

% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean.

    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];

% cnfg.cnfg_disc(1).name = 'Zusatzscheibe';
% cnfg.cnfg_disc(1).position = 300e-3;                 %disc position [m]
% cnfg.cnfg_disc(1).radius = 200e-3;  
% cnfg.cnfg_disc(1).m = 5;                             %disc mass [kg]
% cnfg.cnfg_disc(1).Ix = 1e-4;                         %disc mom. of inertia [m^4]
% cnfg.cnfg_disc(1).Iz = 1e-4;                         %disc mom. of inertia [m^4]

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

count = 1;
cnfg.cnfg_sensor(count).name = 'Wirbelstrom Lager1';
cnfg.cnfg_sensor(count).position=0.110;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Welle 1';
cnfg.cnfg_sensor(count).position=0.200;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Scheibe';
cnfg.cnfg_sensor(count).position=0.355;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Welle 2';
cnfg.cnfg_sensor(count).position=0.500;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
cnfg.cnfg_sensor(count).position=0.630;
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

% count = count + 1;
% cnfg.cnfg_bearing(count).name = 'Torque Lager Links';
% cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
% cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
% cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
% cnfg.cnfg_bearing(count).damping = 100;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=110e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=630e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 299.275;


%% ========================================================================
% Kraft in feste Richtung
cnfg.cnfg_load=[];
count = 0;

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
% cnfg.cnfg_load(count).betrag = 5e-6;
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';

% Sinusförmige Anregungskraft
count = count + 1;
cnfg.cnfg_load(count).name='Sinus Kraft';
cnfg.cnfg_load(count).position=110e-3;
cnfg.cnfg_load(count).betrag_x= 10;
cnfg.cnfg_load(count).frequency_x= 500;  %in Hz
cnfg.cnfg_load(count).betrag_y= 0;
cnfg.cnfg_load(count).frequency_y= 50;
cnfg.cnfg_load(count).type='Force_timevariant_fix';


%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];