%% ========================================================================
% Rotor

cnfg_rotor.name = "Testrotor vom Feinsten";
cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
cnfg_rotor.rotor_dimensions = [0,15,0;300,15,0;350,150,0;600,15,0]*1e-3; %[m] %Angefangen bei 0, die Durchmesserspr�nge am ende des Abschnites eingeben
cnfg_rotor.shear_factor   = 0.9;  %!!!!!!!!!wird Automatisch korregiert wenn Kreisring.
                                %!!!!!!!!!Schubkorrekrutfaktor f�r Kreisquerschnitt 0.9[-], Kreisring 0.5[-]

cnfg_rotor.E_module = 211e9;                            %[N/m^2]
cnfg_rotor.density  = 7446;                             %[kg/m^3]
cnfg_rotor.poisson  = 0.3;                             %steel 0.27...0.3 [-]

cnfg_rotor.dz=0.01;                %set elemet length for meshing

    
%% ========================================================================
% Massescheiben
cnfg_disc(1).name = 'Zusatzscheibe';
cnfg_disc(1).position = 300e-3;                         %disc position [m]
cnfg_disc(1).m = 5;                             %disc mass [kg]
cnfg_disc(1).Ix = 1e-4;                         %disc mom. of inertia [m^4]
cnfg_disc(1).Iz = 1e-4;                         %disc mom. of inertia [m^4]

%% ========================================================================
% Sensors
cnfg_sensor(1).name = 'Sepp';
cnfg_sensor(1).position=0.025;
cnfg_sensor(1).type=1;

cnfg_sensor(2).name='Hans';
cnfg_sensor(2).position=0.225;
cnfg_sensor(2).type=1;

cnfg_sensor(3).name='Kraft';
cnfg_sensor(3).position=0.525;
cnfg_sensor(3).type=2;

%% ========================================================================
% Lager
cnfg_lager(1).name = 'Locker l�ssiges Lager';
cnfg_lager(1).position=0e-3;                        %[m]
cnfg_lager(1).type=1;
cnfg_lager(1).stiffness=5e7;%7.0e5;              %[N/m]

% Lager
cnfg_lager(2).name = 'Straffes l�ssiges Lager';
cnfg_lager(2).position=600e-3;                        %[m]
cnfg_lager(2).type=1;
cnfg_lager(2).stiffness=4e3;                  %[N/m]

%% ========================================================================
% Unwuchten
cnfg_unbalance(1).name = 'Geplante Unwucht';
cnfg_unbalance(1).position = 300e-3;
cnfg_unbalance(1).betrag = 5e-3;
cnfg_unbalance(1).winkellage = 0;

