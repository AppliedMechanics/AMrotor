%% ========================================================================
% Rotor
% Aufbau eines Structs mit den Rotordaten

cnfg.cnfg_rotor.name = 'DPS - Rotor fuer Modalanalyse bzw. Campbell';

cnfg.cnfg_rotor.material.name = 'steel';
cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3] %%SI EINHEITEN!!
cnfg.cnfg_rotor.material.poisson  = 0.3;    %steel 0.27...0.3 [-]
cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1.68999e-05;%0.001;    %D=alpha1*K + alpha2*M
cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 16.04136;%0.001; % Werte aus estimate_damping_proportional.m

% Rotor Config
% r_Welle = 7.5e-3; % Radius der Welle
% r_Laeufer_D = 23e-3; %neu 23mm
% r_Laeufer_ML = 23e-3; % Radius Laeufer des Magnetlagers 
% r_Laeufer_D_innen = 11e-3; % Innenradius D Laeufer, sodass I und m wie in Realitaet
% r_Laeufer_ML_innen = 1e-3; % Innenradius ML Laeufer, sodass I und m wie in Realitaet
% cnfg.cnfg_rotor.geo_nodes = {[0 r_Welle 0], [0.118 r_Welle 0], ...
%     [0.118 r_Laeufer_ML r_Laeufer_ML_innen],...
%     [0.158 r_Laeufer_ML r_Laeufer_ML_innen], [0.158 r_Welle 0], ...
%     [0.205 r_Welle 0], [0.205 r_Laeufer_D r_Laeufer_D_innen],...
%     [0.355 r_Laeufer_D r_Laeufer_D_innen], [0.355 r_Welle 0],...
%     [0.402 r_Welle 0], [0.402 r_Laeufer_ML r_Laeufer_ML_innen],...
%     [0.442 r_Laeufer_ML r_Laeufer_ML_innen], [0.442 r_Welle 0],...
%     [0.600 r_Welle 0]}; % Format {[z, r_aussen, r_innen], ...} % ohne Anfangs und Endknoten
% clear r_Welle r_Laeufer_D r_Laeufer_ML r_Laeufer_D_innen r_Laeufer_ML_innen

% Geometrie wie in der Masterarbeit tab:DPSGeometrie
% Abschnitte A,B,C,D,E,F als 1,2,3,4,5,6
% A = [0.000170842, 0.001230754, 0.001631406, 0.001563023, 0.001139769, 0.001208152];
% I = [2.32316E-09, 1.21911E-07, 2.13906E-07, 2.0211E-07, 1.76151E-07, 1.87946E-07];
% [ra,ri] = calculate_radii_from_IA(A,I);

% cnfg.cnfg_rotor.geo_nodes = {[0 ra(2) ri(2)], [.018 ra(2) ri(2)], ... % Abschnitt B
%     [.018 ra(1) ri(1)], [.118 ra(1) ri(1)], ... % Abschnitt A
%     [.118 ra(3) ri(3)], [.158 ra(3) ri(3)], ... % Abschnitt C
%     [.158 ra(1) ri(1)], [.215 ra(1) ri(1)], ... % Abschnitt A
%     [.215 ra(4) ri(4)], [.233 ra(4) ri(4)], ... % Abschnitt D
%     [.233 ra(5) ri(5)], [.258 ra(5) ri(5)], ... % Abschnitt E
%     [.258 ra(6) ri(6)], [.302 ra(6) ri(6)], ... % Abschnitt F
%     [.302 ra(5) ri(5)], [.327 ra(5) ri(5)], ... % Abschnitt E
%     [.327 ra(4) ri(4)], [.345 ra(4) ri(4)], ... % Abschnitt D
%     [.345 ra(1) ri(1)], [.402 ra(1) ri(1)], ... % Abschnitt A
%     [.402 ra(3) ri(3)], [.442 ra(3) ri(3)], ... % Abschnitt C
%     [.442 ra(1) ri(1)], [.542 ra(1) ri(1)], ... % Abschnitt A
%     [.542 ra(2) ri(2)], [.560 ra(2) ri(2)], ... % Abschnitt B
%     [.560 ra(1) ri(1)], [.580 ra(1) ri(1)], ... % Abschnitt A
%     }; % Endknoten
% clear A I ra ri
rW = 8e-3;
rB=1.*rW;
rML=1.1*rW;
rS=1.1*rW;
cnfg.cnfg_rotor.geo_nodes = {[0 rB 0], [.018 rB 0], [.018 rW 0], [.118 rW 0], [.118 rML 0], [.158 rML 0], [.158 rW 0], ... % Sinn der feinen Aufteilung: Damit Knotenpositionen der Komponenten exakt sind
    [.158 rW 0], [.215 rW 0], [.215 rS 0], [.345 rS 0], [.345 rW 0],... %hier evtl. noch feinere Aufteilung (Dichtungslauefer)
    [.402 rW 0], [.402 rML 0], [.442 rML 0], [.442 rW 0], [.542 rW 0],...
    [.542 rB 0], [.560 rB 0], [.560 rW 0] [.580 rW 0]};



% FEM Config
cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
cnfg.cnfg_rotor.mesh_opt.d_min= 0.002;
cnfg.cnfg_rotor.mesh_opt.d_max = 0.005;
cnfg.cnfg_rotor.mesh_opt.approx = 'lower sum';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean, symmetric.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 2';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.004;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.010;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
% cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 3';
% cnfg.cnfg_rotor.mesh_opt.n_refinement = 10; %number of refinement steps between d_min and d_max 
% cnfg.cnfg_rotor.mesh_opt.d_min = 0.02;
% cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
% cnfg.cnfg_rotor.mesh_opt.approx = 'mean';   %Approximation for linear functions with gradient 1=0;
%                                 % Insert: upper sum, lower sum, mean, symmetric.
    
%% ========================================================================
% Massescheiben
cnfg.cnfg_disc=[];
count = 0;

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
cnfg.cnfg_disc(count).name = 'KuLa L Disc';
cnfg.cnfg_disc(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_disc(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_disc(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_disc(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

count=count+1;
Komp=Disc.MLL;
cnfg.cnfg_disc(count).name = 'MLL Disc';
cnfg.cnfg_disc(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_disc(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_disc(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_disc(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

% diskrete Massescheibe
% count=count+1;
% Komp=Disc.Seal;
% cnfg.cnfg_disc(count).name = 'SealDisc Disc';
% cnfg.cnfg_disc(count).position = Komp.position;                  %disc position [m]
% cnfg.cnfg_disc(count).radius = Komp.r*2;                      %only for plot
% cnfg.cnfg_disc(count).m = Komp.m;                           %disc mass [kg]
% cnfg.cnfg_disc(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
% cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

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
    cnfg.cnfg_disc(count).name = ['SealDisc',num2str(k),'a']; 
    cnfg.cnfg_disc(count).position = leftNode;                 %disc position [m]
    cnfg.cnfg_disc(count).radius = Komp.r;  
    cnfg.cnfg_disc(count).m = Komp.m*factor;                       %disc mass [kg]
    cnfg.cnfg_disc(count).Jx = Komp.Jx*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_disc(count).Jz = Komp.Jz*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;     %disc polar mom. of inertia [kg*m^2]
    %rechter Knoten:
    count = count+1;
    cnfg.cnfg_disc(count).name = ['SealDisc',num2str(k),'b']; 
    cnfg.cnfg_disc(count).position = rightNode;                 %disc position [m]
    cnfg.cnfg_disc(count).radius = Komp.r;  
    cnfg.cnfg_disc(count).m = Komp.m*factor;                       %disc mass [kg]
    cnfg.cnfg_disc(count).Jx = Komp.Jx*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_disc(count).Jz = Komp.Jz*factor;                  %disc mom. of inertia [kg*m^2]
    cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;     %disc polar mom. of inertia [kg*m^2]
end

count=count+1;
Komp=Disc.MLR;
cnfg.cnfg_disc(count).name = 'MLR Disc';
cnfg.cnfg_disc(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_disc(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_disc(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_disc(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

count=count+1;
Komp=Disc.KuLaR;
cnfg.cnfg_disc(count).name = 'KuLa R Disc';
cnfg.cnfg_disc(count).position = Komp.position;                  %disc position [m]
cnfg.cnfg_disc(count).radius = Komp.r;                      %only for plot
cnfg.cnfg_disc(count).m = Komp.m;                           %disc mass [kg]
cnfg.cnfg_disc(count).Jx = Komp.Jx;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jz = Komp.Jz;                         %disc mom. of inertia [kg*m^2]
cnfg.cnfg_disc(count).Jp = cnfg.cnfg_disc(count).Jz;        %disc polar mom. of inertia [kg*m^2] (polar)

%% ========================================================================
% Sensors
cnfg.cnfg_sensor=[];

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

%% ========================================================================
% Lager
cnfg.cnfg_bearing=[];

count = 1;
cnfg.cnfg_bearing(count).name = 'Axiales Lager Links';
cnfg.cnfg_bearing(count).position=0e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleAxialBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Torque Lager Links'; % Was macht das Torque Lager?
cnfg.cnfg_bearing(count).position=9e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleTorqueBearing';
cnfg.cnfg_bearing(count).stiffness=1e10;                     %[N/m]
cnfg.cnfg_bearing(count).damping = 0;

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 1';
cnfg.cnfg_bearing(count).position=9e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=2e8; %von Wagner (bearingTPFax10000Full.mat)                %[N/m]
cnfg.cnfg_bearing(count).damping = 0; % ???

count = count + 1;
cnfg.cnfg_bearing(count).name = 'Isotropes Lager 2';
cnfg.cnfg_bearing(count).position=551e-3;                        %[m]
cnfg.cnfg_bearing(count).type='SimpleBearing';
cnfg.cnfg_bearing(count).stiffness=2e8; % von Wagner (bearingTPFax10000Full.mat)                   %[N/m]
cnfg.cnfg_bearing(count).damping = 0; % ???


%% ========================================================================
cnfg.cnfg_load=[];


%% ========================================================================
% Dichtungen
count = 0;
cnfg.cnfg_seal = [];

count = count+1;
cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
cnfg.cnfg_seal(count).position=250e-3;                        %[m]
cnfg.cnfg_seal(count).type='LookUpTableSeal';
cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(Seal1Filename); 
%cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigNeu1Laminar.mat'); 
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigLam1.mat'); 
%cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigNew1.mat'); 

count = count+1;
cnfg.cnfg_seal(count).name = 'Dichtung LookUpTable';
cnfg.cnfg_seal(count).position=310e-3;                        %[m]
cnfg.cnfg_seal(count).type='LookUpTableSeal';
cnfg.cnfg_seal(count).sealModel.Table = load_seal_table(Seal2Filename);
%cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigNeu2Laminar.mat'); 
% cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigLam2.mat'); 
%cnfg.cnfg_seal(count).sealModel.Table = load_seal_table('Inputfiles/SealTestRigNew2.mat'); 

%% ========================================================================
% Nonlinear-Seals
% Muszynska-Seal laminar
count = 0;
cnfg.cnfg_sealNonLinear = [];