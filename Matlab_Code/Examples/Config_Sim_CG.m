%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'Testrotor';
cnfg.cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
cnfg.cnfg_rotor.rotor_dimensions = [0,10,0;600,10,0]*1e-3; 
% cnfg.cnfg_rotor.rotor_dimensions = [0,10,0;400,10,0;410,150,0;600,10,0]*1e-3; %[m] %Angefangen bei 0, die Durchmessersprünge am ende des Abschnites eingeben
cnfg.cnfg_rotor.shear_factor   = 0.9;  %!!!!!!!!!wird Automatisch korregiert wenn Kreisring.
                                %!!!!!!!!!Schubkorrekrutfaktor für Kreisquerschnitt 0.9[-], Kreisring 0.5[-]

cnfg.cnfg_rotor.E_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.density  = 7446;   %[kg/m^3]
cnfg.cnfg_rotor.poisson  = 0.3;    %steel 0.27...0.3 [-]

cnfg.cnfg_rotor.dz=0.01;           %set elemet length for meshing

    
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

%   cnfg.cnfg_sensor(1).name = 'Sepp';
%   cnfg.cnfg_sensor(1).position=0.050;
%   cnfg.cnfg_sensor(1).type=1;
% % 
% cnfg.cnfg_sensor(2).name='Hans';
% cnfg.cnfg_sensor(2).position=0.550;
% cnfg.cnfg_sensor(2).type=1;

% cnfg.cnfg_sensor(3).name='Maeir';
% cnfg.cnfg_sensor(3).position=0.325;
% cnfg.cnfg_sensor(3).type=1;
% 
% cnfg.cnfg_sensor(2).name='Kraftsensor 1';
% cnfg.cnfg_sensor(2).position=0;
% cnfg.cnfg_sensor(2).type=2;
% % 
% cnfg.cnfg_sensor(4).name='Kraftsensor 2';
% cnfg.cnfg_sensor(4).position=0.6;
% cnfg.cnfg_sensor(4).type=2;

% cnfg.cnfg_sensor(2).name='Velocitysensor 1';
% cnfg.cnfg_sensor(2).position=0.05;
% cnfg.cnfg_sensor(2).type=3;

%cnfg.cnfg_sensor(1).name='Accelerationsensor 1';
%cnfg.cnfg_sensor(1).position=0.05;
%cnfg.cnfg_sensor(1).type=4;

%% ========================================================================
% Lager
cnfg.cnfg_lager=[];

cnfg.cnfg_lager(1).name = 'Locker lässiges Lager';
cnfg.cnfg_lager(1).position=0e-3;                        %[m]
cnfg.cnfg_lager(1).type=1;
cnfg.cnfg_lager(1).stiffness=5e17;                     %[N/m]


cnfg.cnfg_lager(2).name = 'Locker lässiges Lager 2';
cnfg.cnfg_lager(2).position=600e-3;                        %[m]
cnfg.cnfg_lager(2).type=1;
cnfg.cnfg_lager(2).stiffness=5e17;%7.0e5;              %[N/m]
% Lager
%cnfg.cnfg_lager(2).name = 'Ein Magnet-Lager';
%cnfg.cnfg_lager(2).position=600e-3;                        %[m]
%cnfg.cnfg_lager(2).type=2;
%Config_Sim_Mag1
%cnfg.cnfg_lager(2).mag=mag;
%cnfg.cnfg_lager(2).stiffness=5e6;                  %[N/m]



%% ========================================================================
% Kraft in feste Richtung
cnfg.cnfg_force_const_fix=[];
cnfg.cnfg_force_const_fix(1).name='Saubere Kraft';
cnfg.cnfg_force_const_fix(1).position=300e-3;
cnfg.cnfg_force_const_fix(1).betrag_x= 100;
cnfg.cnfg_force_const_fix(1).betrag_y= 100;


% Unwuchten
cnfg.cnfg_unbalance=[];
%  cnfg.cnfg_unbalance(1).name = 'Geplante Unwucht';
%  cnfg.cnfg_unbalance(1).position = 300e-3;
%  cnfg.cnfg_unbalance(1).betrag = 5e-1;
%  cnfg.cnfg_unbalance(1).winkellage = 0;

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

