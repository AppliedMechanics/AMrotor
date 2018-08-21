%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'MLPS - Rotor';
cnfg.cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy


cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.shear_factor = 0.9;

% Rotor Config
cnfg.cnfg_rotor.geo_nodes = {[0 0], [0 0.004], [0.3495 0.004], [0.3495 0.069], [0.3605 0.069], [0.3605 0.004], [0.695 0.004]};

% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.d_min= 0.001;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.009;
cnfg.cnfg_rotor.mesh_opt.approx = 'upper sum';   %Approximation for linear functions with gradient 1=0;
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
cnfg.cnfg_sensor(count).type=1;

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Welle 1';
cnfg.cnfg_sensor(count).position=0.200;
cnfg.cnfg_sensor(count).type=1;

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Scheibe';
cnfg.cnfg_sensor(count).position=0.355;
cnfg.cnfg_sensor(count).type=1;

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Welle 2';
cnfg.cnfg_sensor(count).position=0.500;
cnfg.cnfg_sensor(count).type=1;

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
cnfg.cnfg_sensor(count).position=0.630;
cnfg.cnfg_sensor(count).type=1;

%cnfg.cnfg_sensor(3).name='Kraft-Lager1';
%cnfg.cnfg_sensor(3).position=0.525;
%cnfg.cnfg_sensor(3).type=2;
%cnfg.cnfg_sensor(count).color = 'red';

%% ========================================================================
% Lager
% Lager
cnfg.cnfg_lager=[];

cnfg.cnfg_lager(1).name = 'Isotropes Lager 1';
cnfg.cnfg_lager(1).position=110e-3;                        %[m]
cnfg.cnfg_lager(1).type=1;
cnfg.cnfg_lager(1).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_lager(1).damping = 299.275;


cnfg.cnfg_lager(2).name = 'Isotropes Lager 2';
cnfg.cnfg_lager(2).position=630e-3;                        %[m]
cnfg.cnfg_lager(2).type=1;
cnfg.cnfg_lager(2).stiffness=0.0670680e7;                     %[N/m]
cnfg.cnfg_lager(2).damping = 299.275;

% Config_Sim_Mag1
% cnfg.cnfg_lager(1).name = 'Magnetlager 1';
% cnfg.cnfg_lager(1).position=110e-3;                        %[m]
% cnfg.cnfg_lager(1).type=2;
% cnfg.cnfg_lager(1).mag=mag;
%           
% 
% cnfg.cnfg_lager(2).name = 'Magnetlager 2';
% cnfg.cnfg_lager(2).position=630e-3;                        %[m]
% cnfg.cnfg_lager(2).type=2;
% cnfg.cnfg_lager(2).mag=mag;
                

%% ========================================================================
% Kraft in feste Richtung
cnfg.cnfg_force_const_fix=[];
cnfg.cnfg_force_const_fix(1).name='Const. Kraft';
cnfg.cnfg_force_const_fix(1).position=350e-3;
cnfg.cnfg_force_const_fix(1).betrag_x= 0;
cnfg.cnfg_force_const_fix(1).betrag_y= 100;

% Unwuchten
cnfg.cnfg_unbalance=[];
% cnfg.cnfg_unbalance(1).name = 'Kleine Unwucht';
% cnfg.cnfg_unbalance(1).position = 300e-3;
% cnfg.cnfg_unbalance(1).betrag = 5e-1;
% cnfg.cnfg_unbalance(1).winkellage = 0;

%% Infos
% %KoSy:
%        Z-Längsachse des Rotors
%        X-Z-Ebene
%        verschiebung in X1       X1
%        drehung um Y1            Beta_1
%        verschiebung in X2       X2
%        drehung um Y2            Beta_2
%                                  :
%                                 Xn
%        
%        Y-Z-Ebene
%        verschiebung in Y1       Y1
%        drehung um Z1            Alpha_1
%        verschiebung in Y2       Y3
%        drehung um Z2            Alpha_2
%                                   :
%                                 Yn
%                                 Alpha_n

