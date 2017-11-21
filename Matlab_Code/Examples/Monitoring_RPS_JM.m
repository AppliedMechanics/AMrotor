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
Debugging = 0;

%% Parameter
Monitoring_RPS_JM_Config

%% EigenSchwingForm
% .......ESF Messung am Rotor...........
 load('+AMrotorMONI\RotorConfiguration\ESF1_OldRotor_Measures.mat');
 ESF1.uESF1=uESF1;% vektor der bei Load geladen wird heiﬂt so
 ESF1.zESF1=zESF1;% vektor der bei Load geladen wird heiﬂt so


%% Messdaten

%--------------Messung am Rotor----------------------------------
% % .........Erste Messreihe...........
 load('+AMrotorMONI\MeasurementDataRotor\DataSetAlt.mat');
% DataSetAlt=DataSetAlt;% vektor der bei Load geladen wird heiﬂt so
% % .........Zweite Messreihe...........
 load('+AMrotorMONI\MeasurementDataRotor\DataSetNeu.mat');
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
% KraftMonitor;


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
% PosiMonitor;


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
KombiMonitorDifferential.show;
 

%% Plot von Vektoren
%Graphs.Plott