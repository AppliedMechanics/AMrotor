%% Tutorialanwendung
% Zur Demonstration der AMrotorSIM-Toolbox

%% Header

% Robert Hˆfer, Johannes Maierhofer
% 28.07.2017

%% Import
import AMrotorMONI.*

%% Clean up
close all
clear all
clc


%% Debugging Schalter
% Maximal 12 Mesreihen pro Datensatz f¸r sinvolle Plotdarstellung
% 1 = an;   0 = aus
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Debugging = 1;

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%% Parameter

% %........Manuelle Eingabe Rotorparameter..
% cnfg.Lagerabstand = 0.60;               %Abstand zwischen den beiden Auflagern in Meter
% cnfg.Steifigkeit= 1.2475e+4;%210000e+6*pi*0.008^4/64;
% cnfg.Eigenfrequenz =  79.5005;         %Eigenfrequenz des Rotors in rad/sec.
% cnfg.ModaleMasse1EO = 1.9737;   % kg bei Laval gleich mit Gesammtmasse
% cnfg.MasseRotorGesamt = 1.9737;  % scheibe 6.6268 kg
% cnfg.zPosUnwucht = 0.5075;
% cnfg.zPosSensor = 0.5075;

% %........LavalRotorParameter 2D.......
% LavalParamter_3D = ['.\+AMrotorMONI\Simulation_Laval\','LavalParameter_2D','.mat'];
% load(LavalParamter_2D)
% cnfg=cnfgLavalSim_2D;% vektor der bei Load geladen wird heiﬂt so

% %........LavalRotorParameter 3D.......
LavalParamter_3D = ['H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\','LavalParameter_3D','.mat'];
load(LavalParamter_3D)
cnfg=cnfgLavalSim_3D;% vektor der bei Load geladen wird heiﬂt so



%% EeigenSchwingForm


% .......ESF ALter Messung am Rotor...........
% ESF1_path = ['.\+AMrotorMONI\RotorConfiguration\','ESF1_OldRotor_Measures','.mat'];
% load(ESF1_path);
% ESF1.uESF1=uESF1;% vektor der bei Load geladen wird heiﬂt so
% ESF1.zESF1=zESF1;% vektor der bei Load geladen wird heiﬂt so

% .......ESF Simulation LavalRotor3D..........
ESF1_path = ['H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\RotorConfiguration\','ESF1_Simulation_Laval_3D','.mat'];
load(ESF1_path);
ESF1.uESF1=uESF1;% vektor der bei Load geladen wird heiﬂt so
ESF1.zESF1=zESF1;% vektor der bei Load geladen wird heiﬂt so

% .......Alibi ESF Simulation LavalRotor2D..........
% F¸r Tool notwendig enlh‰lt allerdings nur 1 er
% ESF1_path = ['.\+AMrotorMONI\RotorConfiguration\','ESF1_Simulation_Laval_2D','.mat'];
% load(ESF1_path);
% ESF1.uESF1=uESF1;% vektor der bei Load geladen wird heiﬂt so
% ESF1.zESF1=zESF1;% vektor der bei Load geladen wird heiﬂt so





%% Messdaten

%--------------Alte Kraftmessung am Rotor----------------------------------
% % .........Erste Messreihe...........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\MeasurementDataRotor\DataSetAlt.mat');
% DataSetAlt=DataSetAlt;% vektor der bei Load geladen wird heiﬂt so
% % .........Zweite Messreihe...........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\MeasurementDataRotor\DataSetNeu.mat');
% DataSetNeu=DataSetNeu;% vektor der bei Load geladen wird heiﬂt so


%--------------Johannes Simulationsdaten-----------------------------------
%  load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_RH_v03\dataset_monitoring_Unwucht1e-4_0eins_mit_Richtiger_drehzahl.mat');
%  DataSetNeu=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so
%  load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_RH_v03\dataset_monitoring_Unwucht1e-4_0zwei_mit_Richtiger_drehzahl.mat');
%  DataSetAlt=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so


%--------------Laval Rotor Simulationsdaten--------------------------------
% % .........Simulation 2D..........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\DataSetSim_2D.mat');
% DataSetSim_2D=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so
% % .........Simulation 3D..........
 load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\DataSetSim_3D.mat');
 DataSetSim_3D=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so


%--------------Laval Rotor Simulationsdaten mit Fehler---------------------
% % ......... 10 % Rauschen ..........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\Rauschen_20p_DataSetSim_3D.mat');
% DataSetSim_3D=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so
% ......... + 5∞ Verdrehen bei jeder Drehzahl ..........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\Verdreh_1_Grad_DataSetSim_3D.mat');
% DataSetSim_3D=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so
% % ......... + - 2,5∞ Oszilieren zwischen Drehzahl ..........
% load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\Simulation_Laval\Oszi_5_Grad_DataSetSim_3D.mat');
% DataSetSim_3D=dataset_monitoring;% vektor der bei Load geladen wird heiﬂt so


%% TUM Farben
load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\TUMFarben.mat')
cnfg.TUM=TUM;

%% Lagerkrafmessung
% Instanzieren des Objekts
KraftMonitor = BearingForceApproach('KraftMonitor');
KraftMonitor.cnfg=cnfg;
KraftMonitor.Debugging=Debugging;
% Aufruf Berechungsfunktion
KraftMonitor.initialize(DataSetSim_3D);
KraftMonitor.revise(DataSetSim_3D);
KraftMonitor.show;
KraftMonitor;


%% Positionsmessung
% Instanzieren des Objekts
PosiMonitor = RotorDeflectionApproach('PositionsMonitor');
PosiMonitor.cnfg = cnfg;
PosiMonitor.ESF1 = ESF1;
PosiMonitor.Debugging=Debugging;
% Aufruf Berechnungsfunktionen
PosiMonitor.initialize(DataSetSim_3D);
PosiMonitor.revise(DataSetSim_3D);
PosiMonitor.show;
PosiMonitor;


%% Kombination Lagerkraft und Positionsmessung
% Implementierung der Klasse

KombiMonitorInitial = CombinedForceDeflectionApproach('KombiniertesMonitoringInitial');
KombiMonitorInitial.cnfg = cnfg;
KombiMonitorRevisional = CombinedForceDeflectionApproach('KombiniertesMonitoringRevisional');
KombiMonitorRevisional.cnfg = cnfg;
KombiMonitorDifferential = CombinedForceDeflectionApproach('KombiniertesMonitoringDifferential');
KombiMonitorDifferential.cnfg = cnfg;

%% Aufruf Berechungsfunktionen

KombiMonitorInitial.calculation(PosiMonitor.XInitial,KraftMonitor.Bearing1_Initialforce,KraftMonitor.Bearing2_Initialforce);
KombiMonitorInitial.show;
% KombiMonitorRevisional.calculation(PosiMonitor.XRevisional,KraftMonitor.Bearing1_Revisionalforce,KraftMonitor.Bearing2_Revisionalforce);
% KombiMonitorRevisional.show;
% KombiMonitorDifferential.calculation(PosiMonitor.XDifferential,KraftMonitor.Bearing1_Differentialforce,KraftMonitor.Bearing2_Differentialforce);
% KombiMonitorDifferential.show
 

%% Plot von Vektoren
Plott