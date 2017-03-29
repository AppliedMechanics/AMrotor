%% ========================================================================
% Rotor

cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
cnfg_rotor.rotor_dimensions = [0,15,0;300,15,0;600,15,0]*1e-3; %[m] %Angefangen bei 0, die Durchmessersprünge am ende des Abschnites eingeben

cnfg_rotor.shear_factor   = 0.9;  %!!!!!!!!!wird Automatisch korregiert wenn Kreisring.
                                %!!!!!!!!!Schubkorrekrutfaktor für Kreisquerschnitt 0.9[-], Kreisring 0.5[-]
                                

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
cnfg_lager(1).name = 'Locker lässiges Lager';
cnfg_lager(1).position=0.0;
cnfg_lager(1).type=1;
cnfg_lager(1).stiffness=4000;
