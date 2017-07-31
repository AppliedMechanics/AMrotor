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

%% Datenvorbereitung
[dataset, datasetNeu]=Datenaufbereitung;

%% Parameter
% Rotorparameter
cnfg.Lagerabstand = 0.59;               %Abstand zwischen den beiden Auflagern in Meter
cnfg.Eigenfrequenz = 63.5*2*pi;         %Eigenfrequenz des Rotors in rad/sec.
cnfg.ModaleMasse1EO = 5.817;
cnfg.MasseRotorGesamt = 11.123;
% Eigenschwingform Rotor
ESF1_path = ['.\+AMrotorMONI\RotorConfiguration\','ESF1','.mat'];
load(ESF1_path);
ESF1.uESF1=uESF1;
ESF1.zESF1=zESF1;

% Parameter für das Monitoring
cnfg.zPosUnwucht = 0.095;
cnfg.zPosSensor = 0.3050;



%% Lagerkrafmessung
% Instanzieren eines Objekts
KraftMonitor = BearingForceApproach('KraftMonitor');
KraftMonitor.cnfg=cnfg;

% Aufruf Berechnungsfunktionen
KraftMonitor.initialize(dataset);
KraftMonitor.revise(datasetNeu);
KraftMonitor.show;


%% Positionsmessung
% Ende Parameter, Übergabe Parameter an Klasse
PosiMonitor = RotorDeflectionApproach('PositionsMonitor');
PosiMonitor.cnfg = cnfg;
PosiMonitor.ESF1 = ESF1;

% Aufruf Berechnungsfunktionen
PosiMonitor.initialize(dataset);
PosiMonitor.revise(datasetNeu);
PosiMonitor.show;


%% Kombination Lagerkraft und Positionsmessung
% Implementierung der Klasse
KombiMonitor = CombinedForceDeflectionApproach('KombiniertesMonitoring');

% Aufruf Berechungsfunktionen
%KombiMonitor.initialize;
%KombiMonitor.revise;
%KombiMonitor.show;