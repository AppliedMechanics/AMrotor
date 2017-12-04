%% ========================================================================
% Rotor

cnfg.cnfg_rotor.name = "Testrotor";
cnfg.cnfg_rotor.shear_def = 1;     % 1 = Timoshenko or 0 = Bernoulli beam theoy

%rotor geometry             [z1,da,di;   z2,da,di]  
cnfg.cnfg_rotor.rotor_dimensions = [0,15,0;400,15,0;450,150,0;600,15,0]*1e-3; %[m] %Angefangen bei 0, die Durchmessersprünge am ende des Abschnites eingeben
cnfg.cnfg_rotor.shear_factor   = 0.9;  %!!!!!!!!!wird Automatisch korregiert wenn Kreisring.
                                %!!!!!!!!!Schubkorrekrutfaktor für Kreisquerschnitt 0.9[-], Kreisring 0.5[-]

cnfg.cnfg_rotor.E_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.density  = 7446;   %[kg/m^3]
cnfg.cnfg_rotor.poisson  = 0.3;    %steel 0.27...0.3 [-]

cnfg.cnfg_rotor.dz=0.01;           %set elemet length for meshing

    
%% ======================================================================
% Massescheiben
cnfg.cnfg_disc=[];

%% ======================================================================
% Sensors
cnfg.cnfg_sensor=[];

%% ======================================================================
% Lager
cnfg.cnfg_lager=[];

%% ======================================================================
% Kraft in feste Richtung
cnfg.cnfg_force_const_fix=[];

% Unwuchten
cnfg.cnfg_unbalance=[];

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

