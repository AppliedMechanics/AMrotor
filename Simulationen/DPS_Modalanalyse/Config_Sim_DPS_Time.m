%% ================Rotor===================================================
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'DPS - Rotor fuer Zeitintegration mit Dichtung';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1.68999e-05;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 16.04136;%0.001; % Werte aus estimate_damping_proportional.m


% Rotor Config
rW = 8e-3;
rB=1.*rW;
rML=1.1*rW;
rS=1.1*rW;
cnfg.cnfg_rotor.geo_nodes = {[0 rB 0], [.018 rB 0], [.018 rW 0], [.118 rW 0], [.118 rML 0], [.158 rML 0], [.158 rW 0], ... % Sinn der feinen Aufteilung: Damit Knotenpositionen der Komponenten exakt sind
    [.158 rW 0], [.215 rW 0], [.215 rS 0], [.345 rS 0], [.345 rW 0],... %hier evtl. noch feinere Aufteilung (Dichtungslauefer)
    [.402 rW 0], [.402 rML 0], [.442 rML 0], [.442 rW 0], [.542 rW 0],...
    [.542 rB 0], [.560 rB 0], [.560 rW 0] [.580 rW 0]};


% FEM Config
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.002;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
cnfg.cnfg_rotor.mesh_opt.approx = 'mean';
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.02;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';
    

%% ====================Sensoren============================================
cnfg.cnfg_sensor=[];

% count = 1;
% cnfg.cnfg_sensor(count).name = 'Weg_Lager1';
% cnfg.cnfg_sensor(count).position=pos.Lag1;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_ML1';
% cnfg.cnfg_sensor(count).position=pos.ML1;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% % count = count + 1;
% % cnfg.cnfg_sensor(count).name='Weg_Dichtung1';
% % cnfg.cnfg_sensor(count).position=pos.Dic1;
% % cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_DichtungMitte';
% cnfg.cnfg_sensor(count).position=pos.DicMitte;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% % count = count + 1;
% % cnfg.cnfg_sensor(count).name='Weg_Dichtung2';
% % cnfg.cnfg_sensor(count).position=pos.Dic2;
% % cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_ML2';
% cnfg.cnfg_sensor(count).position=pos.ML2;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Weg_Lager2';
% cnfg.cnfg_sensor(count).position=pos.Lag2;
% cnfg.cnfg_sensor(count).type='Displacementsensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_Lager1';
% cnfg.cnfg_sensor(count).position=pos.Lag1;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_ML1';
% cnfg.cnfg_sensor(count).position=pos.ML1;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% % count = count + 1;
% % cnfg.cnfg_sensor(count).name='Kraft_Dichtung1';
% % cnfg.cnfg_sensor(count).position=pos.Dic1;
% % cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_DichtungMitte';
% cnfg.cnfg_sensor(count).position=pos.DicMitte;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_DichtungMitteNonLinear';
% cnfg.cnfg_sensor(count).position=pos.DicMitte;
% cnfg.cnfg_sensor(count).type='ForceSealsNonLinearPostSensor';
% 
% % count = count + 1;
% % cnfg.cnfg_sensor(count).name='Kraft_Dichtung2';
% % cnfg.cnfg_sensor(count).position=pos.Dic2;
% % cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_ML2';
% cnfg.cnfg_sensor(count).position=pos.ML2;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_Lager2';
% cnfg.cnfg_sensor(count).position=pos.Lag2;
% cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Geschwindigkeit_DichtungMitte';
% cnfg.cnfg_sensor(count).position=pos.DicMitte;
% cnfg.cnfg_sensor(count).type='Velocitysensor';
% 
% count = count + 1;
% cnfg.cnfg_sensor(count).name='Beschleunigung_DichtungMitte';
% cnfg.cnfg_sensor(count).position=pos.DicMitte;
% cnfg.cnfg_sensor(count).type='Accelerationsensor';

count = 1;
cnfg.cnfg_sensor(count).name = 'Wirbelstrom Lager1';
cnfg.cnfg_sensor(count).position=9e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 1';
cnfg.cnfg_sensor(count).position=227e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung Mitte';
cnfg.cnfg_sensor(count).position=280e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Dichtung 2';
cnfg.cnfg_sensor(count).position=333e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Wirbelstrom Lager2';
cnfg.cnfg_sensor(count).position=551e-3;
cnfg.cnfg_sensor(count).type='Displacementsensor';

% count = count + 1;
% cnfg.cnfg_sensor(count).name='Kraft_DichtungMitteNonLinear';
% cnfg.cnfg_sensor(count).position=Disc.Seal.position;
% cnfg.cnfg_sensor(count).type='ForceSealsNonLinearPostSensor';

count = count + 1;
cnfg.cnfg_sensor(count).name='Kraft_Lager2';
cnfg.cnfg_sensor(count).position=551e-3;
cnfg.cnfg_sensor(count).type='ForceLoadPostSensor';

%% =========================Lasten=========================================
cnfg.cnfg_load=[];
count = 0;

% Kraft in feste Richtung
count = count + 1;
cnfg.cnfg_load(count).name='Const. Kraft';
cnfg.cnfg_load(count).position=422e-3;
cnfg.cnfg_load(count).betrag_x= 0;
cnfg.cnfg_load(count).betrag_y= -1e-2;
cnfg.cnfg_load(count).type='Force_constant_fix';

% Unwuchten
% count = count + 1;
% cnfg.cnfg_load(count).name = 'Kleine Unwucht';
% cnfg.cnfg_load(count).position = Disc.Seal.position;
% cnfg.cnfg_load(count).betrag = 5e-6;%5e-5;%
% cnfg.cnfg_load(count).winkellage = 0;
% cnfg.cnfg_load(count).type='Unbalance_static';


% Sinusfoermige Anregungskraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Sinus Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).frequency_x= 500;  %in Hz
% cnfg.cnfg_load(count).betrag_y= 0;
% cnfg.cnfg_load(count).frequency_y= 50;
% cnfg.cnfg_load(count).type='Force_timevariant_fix';

% Whirl, Anregungskraft beschreibt Ellipse
% count = count + 1;
% cnfg.cnfg_load(count).name='Whirl Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= 10;
% cnfg.cnfg_load(count).frequency= 500;  %in Hz
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd';

% Chirp, Sinus-sweep-Kraft
% % count = count + 1;
% % cnfg.cnfg_load(count).name='Chirp Kraft';
% % cnfg.cnfg_load(count).position=422e-3; % Position ML 2
% % cnfg.cnfg_load(count).betrag_x= 1e-3;
% % cnfg.cnfg_load(count).frequency_x_0 = 0; % Startfrequenz
% % cnfg.cnfg_load(count).frequency_x= 450;  %in Hz, Endfrequenz
% % cnfg.cnfg_load(count).betrag_y= 0;
% % cnfg.cnfg_load(count).frequency_y_0 = 0;
% % cnfg.cnfg_load(count).frequency_y= 0;
% % cnfg.cnfg_load(count).t_start= 0;
% % cnfg.cnfg_load(count).t_end= 1; % Zeitdauer des Chirps, hier wird f erreicht
% % cnfg.cnfg_load(count).type='Force_timevariant_chirp';

% % fwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Fwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= 0.5; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% 
% % bwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Bwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML1; % Position ML 1
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0.5;
% cnfg.cnfg_load(count).t_end= 1.0;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';
% 
% % fwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Fwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML2; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0; %Zeitpkt an dem Startfrequenz anliegt
% cnfg.cnfg_load(count).t_end= 0.5; % Zeitpkt des Ende des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_fwd_sweep';
% 
% % bwd-whirl-sweep-Kraft
% count = count + 1;
% cnfg.cnfg_load(count).name='Bwd Whirl Sweep Kraft';
% cnfg.cnfg_load(count).position=pos.ML2; % Position ML 2
% cnfg.cnfg_load(count).betrag_x= 10;
% cnfg.cnfg_load(count).betrag_y= cnfg.cnfg_load(count).betrag_x;
% cnfg.cnfg_load(count).frequency_0 = 0; % Startfrequenz
% cnfg.cnfg_load(count).frequency= 200;  %in Hz, Endfrequenz
% cnfg.cnfg_load(count).t_start= 0.5;
% cnfg.cnfg_load(count).t_end= 1.0;%2; % Zeitdauer des Chirps, hier wird f erreicht
% cnfg.cnfg_load(count).type='Force_timevariant_whirl_bwd_sweep';

%% =========================Komponenten====================================
count = 0;
cnfg.cnfg_component = []; 

%% Massescheiben
%Kugellager:
Disc.KuLaL.position = 9e-3;
Disc.KuLaL.r = 15e-3;
Disc.KuLaL.m = 0.105577;
Disc.KuLaL.Jx = 1.600365e-5;
Disc.KuLaL.Jz = 2.464871e-5;

Disc.KuLaR = Disc.KuLaL;
Disc.KuLaR.position = 551e-3;

% Magnetlagerlaeufer
Disc.MLL.position = 138e-3;
Disc.MLL.r = 25e-3;
Disc.MLL.m = 0.420742;
Disc.MLL.Jx = 1.232368e-4;
Disc.MLL.Jz = 1.310192e-4;

Disc.MLR = Disc.MLL;
Disc.MLR.position = 422e-3;

%Dichtungslaeufer
Disc.Seal.position = 280e-3;
Disc.Seal.r = 25e-3;
Disc.Seal.m = 1.084726;
Disc.Seal.Jx = 1.806417e-3;
Disc.Seal.Jz = 3.783162e-4;

count=count+1;
Komp=Disc.KuLaL;
cnfg.cnfg_component(count).name = 'KuLa L Disc';
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_component(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_component(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_component(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

count=count+1;
Komp=Disc.MLL;
cnfg.cnfg_component(count).name = 'MLL Disc';
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_component(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_component(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_component(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

% diskrete Massescheibe
% count=count+1;
% Komp=Disc.Seal;
% cnfg.cnfg_component(count).name = 'SealDisc Disc';
% cnfg.cnfg_component(count).position = Komp.position;                  %disc position [m]
% cnfg.cnfg_component(count).radius = Komp.r*2;                      %only for plot
% cnfg.cnfg_component(count).m = Komp.m;                           %disc mass [kg]
% cnfg.cnfg_component(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_component(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

% Aufteilung der Massescheibe auf alle Knoten von 215 bis 345 mm
Komp=Disc.Seal;
Komp.z = [215, 345]*1e-3; % Bereich in dem Scheibe sein soll
Length = Komp.z(2)-Komp.z(1);
% ohne Korrektur der Scheibenmasse
nEle = ceil(Length/cnfg.cnfg_rotor.mesh_opt.d_max);
nodes = Komp.z(1):Length/nEle:Komp.z(2);
nNodes = length(nodes);
factor = 1/(2*nEle);
for k=1:nEle
    leftNode = nodes(k);
    rightNode = nodes(k+1);
    %linker Knoten:
    count = count+1;
    cnfg.cnfg_component(count).name = ['SealDisc',num2str(k),'a']; 
    cnfg.cnfg_component(count).type = 'Disc';
    cnfg.cnfg_component(count).position = leftNode;                 %disc position [m]
    cnfg.cnfg_component(count).radius = Komp.r;  
    cnfg.cnfg_component(count).m = Komp.m*factor;                       %disc mass [kg]
    cnfg.cnfg_component(count).Jx = Komp.Jx*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_component(count).Jz = Komp.Jz*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;     %disc polar mom. of inertia [kg*m^2]
    %rechter Knoten:
    count = count+1;
    cnfg.cnfg_component(count).name = ['SealDisc',num2str(k),'b'];
    cnfg.cnfg_component(count).type = 'Disc';
    cnfg.cnfg_component(count).position = rightNode;                 %disc position [m]
    cnfg.cnfg_component(count).radius = Komp.r;  
    cnfg.cnfg_component(count).m = Komp.m*factor;                       %disc mass [kg]
    cnfg.cnfg_component(count).Jx = Komp.Jx*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_component(count).Jz = Komp.Jz*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;     %disc polar mom. of inertia [kg*m^2]
end

count=count+1;
Komp=Disc.MLR;
cnfg.cnfg_component(count).name = 'MLR Disc';
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_component(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_component(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_component(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

count=count+1;
Komp=Disc.KuLaR;
cnfg.cnfg_component(count).name = 'KuLa R Disc';
cnfg.cnfg_component(count).type = 'Disc';
cnfg.cnfg_component(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_component(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_component(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_component(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_component(count).Jp = cnfg.cnfg_component(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)


%% Lager
count = count + 1;
cnfg.cnfg_component(count).name = 'Axiales Lager Links';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleAxialBearing';
cnfg.cnfg_component(count).position=0e-3;                        %[m]
cnfg.cnfg_component(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

count = count + 1;
cnfg.cnfg_component(count).name = 'Torque Lager Links';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleTorqueBearing';
cnfg.cnfg_component(count).position=9e-3;                        %[m]
cnfg.cnfg_component(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_component(count).damping = 0;

count = count + 1;
cnfg.cnfg_component(count).name = 'Isotropes Lager 1';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=9e-3;                        %[m]
cnfg.cnfg_component(count).stiffness=2e8; %von Wagner (bearingTPFax10000Full.mat) %wahrscheinlich zu hoch                %[N/m]
cnfg.cnfg_component(count).damping = 0; 

count = count + 1;
cnfg.cnfg_component(count).name = 'Isotropes Lager 2';
cnfg.cnfg_component(count).type='Bearings';
cnfg.cnfg_component(count).subtype='SimpleBearing';
cnfg.cnfg_component(count).position=551e-3;                        %[m]
cnfg.cnfg_component(count).stiffness=2e8; %von Wagner (bearingTPFax10000Full.mat) %wahrscheinlich zu hoch                %[N/m]
cnfg.cnfg_component(count).damping = 0; 

%% LookUpTable Component
% Seals
% count = count+1;
% cnfg.cnfg_component (count).name = 'CompLUTMCK Seal 1';
% cnfg.cnfg_component (count).type='CompLUTMCK'; 
% cnfg.cnfg_component (count).position=250e-3;                        %[m]
% cnfg.cnfg_component (count).Table = load('Inputfiles/SealTestRigEcc/TestRigLam1Ecc0.mat'); 
% % zu ladende Datei muss folgende Variablen enthalten (siehe auch Beispiel):
% % rpm = 1 x Nrpm array
% % mass_matrix = 6 x 6 cell
% % damping_matrix = 6 x 6 cell
% % stiffness_matrix = 6 x 6 cell
% % eine einzelne Zelle besteht aus einem array mit Nrpm Eintraegen fuer jede
% % Drehzahlstufe, z.B. mass_matrix{1,2} = Nrpm x 1 array
% 
% count = count+1;
% cnfg.cnfg_component (count).name = 'CompLUTMCK Seal 2';
% cnfg.cnfg_component (count).type='CompLUTMCK'; 
% cnfg.cnfg_component (count).position=310e-3;                        %[m]
% cnfg.cnfg_component (count).Table = load('Inputfiles/SealTestRigEcc/TestRigLam2Ecc0.mat'); 

%% Seals
count = count+1;
cnfg.cnfg_component(count).name = 'Dichtung Black';
cnfg.cnfg_component(count).type='Seals';
cnfg.cnfg_component(count).subtype='BlackSeal';
cnfg.cnfg_component(count).position=100e-3;                        %[m]
cnfg.cnfg_component(count).sealModel = load_seal_model('ChildsBlackModelParameters.m');

count = count+1;
cnfg.cnfg_component(count).name = 'Dichtung Childs';
cnfg.cnfg_component (count).type='Seals';
cnfg.cnfg_component(count).subtype='ChildsSeal';
cnfg.cnfg_component(count).position=150e-3;                        %[m]
cnfg.cnfg_component(count).sealModel = load_seal_model('ChildsBlackModelParameters.m');


%% ========================PID-Regler======================================
cnfg.cnfg_pid_controller=[];
count = 0;

%% ======================Active Magnetic Bearing===========================
cnfg.cnfg_activeMagneticBearing = [];
count = 0;