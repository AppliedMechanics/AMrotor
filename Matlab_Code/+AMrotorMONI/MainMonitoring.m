%% Tutorialanwendung
% Zur Demonstration der AMrotorSIM-Toolbox

%% Header
% Johannes Maierhofer
% 20.11.2017

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
 cnfg.Lagerabstand = 0.60;                 %Abstand zwischen den beiden Auflagern in Meter
 cnfg.Steifigkeit= 1.2475e+4;              %210000e+6*pi*0.008^4/64;
 cnfg.Eigenfrequenz =  79.5005;            %Eigenfrequenz des Rotors in rad/sec.
 cnfg.ModaleMasse1EO = 1.9737;             % kg bei Laval gleich mit Gesammtmasse
 cnfg.MasseRotorGesamt = 1.9737;           % scheibe 6.6268 kg
 cnfg.zPosUnwucht = 0.5075;
 cnfg.zPosSensor = 0.5075;


%% EigenSchwingForm
% .......ESF Messung am Rotor...........
 load('\RotorConfiguration\ESF1_OldRotor_Measures.mat');
 ESF1.uESF1=uESF1;% vektor der bei Load geladen wird heiﬂt so
 ESF1.zESF1=zESF1;% vektor der bei Load geladen wird heiﬂt so


%% Messdaten

%--------------Messung am Rotor----------------------------------
% % .........Erste Messreihe...........
 load('\MeasurementDataRotor\DataSetAlt.mat');
% DataSetAlt=DataSetAlt;% vektor der bei Load geladen wird heiﬂt so
% % .........Zweite Messreihe...........
 load('\MeasurementDataRotor\DataSetNeu.mat');
% DataSetNeu=DataSetNeu;% vektor der bei Load geladen wird heiﬂt so


%% Lagerkrafmessung
% Instanzieren des Objekts
KraftMonitor = BearingForceApproach('KraftMonitor');
KraftMonitor.cnfg=cnfg;
KraftMonitor.Debugging=Debugging;
% Aufruf Berechungsfunktion
KraftMonitor.initialize(DataSetAlt);
KraftMonitor.revise(DataSetNeu);
KraftMonitor.show;
KraftMonitor;


%% Positionsmessung
% Instanzieren des Objekts
PosiMonitor = RotorDeflectionApproach('PositionsMonitor');
PosiMonitor.cnfg = cnfg;
PosiMonitor.ESF1 = ESF1;
PosiMonitor.Debugging=Debugging;
% Aufruf Berechnungsfunktionen
PosiMonitor.initialize(DataSetAlt);
PosiMonitor.revise(DataSetNeu);
PosiMonitor.show;
PosiMonitor;


%% Kombination Lagerkraft und Positionsmessung

KombiMonitorInitial = CombinedForceDeflectionApproach('KombiniertesMonitoringInitial');
KombiMonitorInitial.cnfg = cnfg;
KombiMonitorRevisional = CombinedForceDeflectionApproach('KombiniertesMonitoringRevisional');
KombiMonitorRevisional.cnfg = cnfg;
KombiMonitorDifferential = CombinedForceDeflectionApproach('KombiniertesMonitoringDifferential');
KombiMonitorDifferential.cnfg = cnfg;

%% Aufruf Berechungsfunktionen

KombiMonitorInitial.calculation(PosiMonitor.XInitial,KraftMonitor.Bearing1_Initialforce,KraftMonitor.Bearing2_Initialforce);
KombiMonitorInitial.show;
KombiMonitorRevisional.calculation(PosiMonitor.XRevisional,KraftMonitor.Bearing1_Revisionalforce,KraftMonitor.Bearing2_Revisionalforce);
KombiMonitorRevisional.show;
KombiMonitorDifferential.calculation(PosiMonitor.XDifferential,KraftMonitor.Bearing1_Differentialforce,KraftMonitor.Bearing2_Differentialforce);
KombiMonitorDifferential.show
 

%% Plot von Vektoren
%Graphs.Plott