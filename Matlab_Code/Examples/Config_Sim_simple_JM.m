%% ======================================================================
% Rotor

cnfg.cnfg_rotor.name = 'Testrotor';
cnfg.cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
% cnfg.cnfg_rotor.rotor_dimensions = [0,10,0;600,10,0]*1e-3; 
cnfg.cnfg_rotor.rotor_dimensions = [0,10,0;400,10,0;410,150,0;600,10,0]*1e-3; %[m] %Angefangen bei 0, die Durchmessersprünge am ende des Abschnites eingeben
cnfg.cnfg_rotor.shear_factor   = 0.9;  
                               

cnfg.cnfg_rotor.E_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.density  = 7446;   %[kg/m^3]
cnfg.cnfg_rotor.poisson  = 0.3;    %steel 0.27...0.3 [-]

cnfg.cnfg_rotor.dz=0.1;           %set elemet length for meshing

    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];


%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

 count = 0;

count = count + 1;
cnfg.cnfg_sensor(count).name='Hans';
cnfg.cnfg_sensor(count).position=0.300;
cnfg.cnfg_sensor(count).type=1;


%% ========================================================================
% Lager
cnfg.cnfg_lager=[];

cnfg.cnfg_lager(1).name = 'Isotropes Lager 1';
cnfg.cnfg_lager(1).position=0e-3;                        %[m]
cnfg.cnfg_lager(1).type=1;
cnfg.cnfg_lager(1).stiffness=5e7;                     %[N/m]


cnfg.cnfg_lager(2).name = 'Isotropes Lager 2';
cnfg.cnfg_lager(2).position=600e-3;                        %[m]
cnfg.cnfg_lager(2).type=1;
cnfg.cnfg_lager(2).stiffness=5e7;                     %[N/m]


%% ========================================================================
% Kraft in feste Richtung
cnfg.cnfg_force_const_fix=[];

% Unwuchten
cnfg.cnfg_unbalance=[];
 cnfg.cnfg_unbalance(1).name = 'Geplante Unwucht';
 cnfg.cnfg_unbalance(1).position = 300e-3;
 cnfg.cnfg_unbalance(1).betrag = 5e-3;
 cnfg.cnfg_unbalance(1).color = 'r';
 cnfg.cnfg_unbalance(1).winkellage = 0;
%  
