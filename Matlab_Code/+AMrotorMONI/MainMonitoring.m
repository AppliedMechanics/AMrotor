%% Tutorialanwendung
% Zur Demonstration der AMrotorSIM-Toolbox

%% Header

% Robert Höfer, Johannes Maierhofer
% 28.07.2017

%% Import
import AMrotorMONI.*

%% Clean up
close all
clear all
clc

Daten_Zusammenstellen

%% Parameter
% Rotorparameter
cnfg.Lagerabstand = 0.59;               %Abstand zwischen den beiden Auflagern in Meter
cnfg.Eigenfrequenz = 63.5*2*pi;         %Eigenfrequenz des Rotors in rad/sec.
cnfg.ModaleMasse1EO = 5.817;
cnfg.MasseRotorGesamt = 11.123;
cnfg.zPosUnwucht = 0.095;
cnfg.zPosSensor = 0.3050;
% Eigenschwingform Rotor
ESF1_path = ['.\+AMrotorMONI\RotorConfiguration\','ESF1','.mat'];
load(ESF1_path);
ESF1.uESF1=uESF1;
ESF1.zESF1=zESF1;


%% Lagerkrafmessung
% Instanzieren eines Objekts
KraftMonitor = BearingForceApproach('KraftMonitor');
KraftMonitor.cnfg=cnfg;

% Aufruf Berechnungsfunktionen
KraftMonitor.initialize(DataSetAlt);
KraftMonitor.revise(DataSetNeu);
KraftMonitor.show;
KraftMonitor;

%% Positionsmessung
% Ende Parameter, Übergabe Parameter an Klasse
PosiMonitor = RotorDeflectionApproach('PositionsMonitor');
PosiMonitor.cnfg = cnfg;
PosiMonitor.ESF1 = ESF1;

% Aufruf Berechnungsfunktionen
PosiMonitor.initialize(DataSetAlt);
PosiMonitor.revise(DataSetNeu);
PosiMonitor.show;
PosiMonitor;


%% Kombination Lagerkraft und Positionsmessung
% Implementierung der Klasse
% KombiMonitor = CombinedForceDeflectionApproach('KombiniertesMonitoring');

% Aufruf Berechungsfunktionen
%KombiMonitor.initialize(PosiMonitor.XInitial,KraftMonitor.Bearing1_Initialforce,KraftMonitor.Bearing2_Initialforce);
%KombiMonitor.revise(PosiMonitor.XRevisional,KraftMonitor.Bearing1_Revisionalforce,KraftMonitor.Bearing2_Revisionalforce);
%KombiMonitor.differenz(PosiMonitor.XDifferential,KraftMonitor.Bearing1_Differentialforce,KraftMonitor.Bearing2_Differentialforce);
%KombiMonitor.show;