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

%% Lagerkrafmessung
% Parameter

cnfg.Lagerabstand = 0.59;               %Abstand zwischen den beiden Auflagern in Meter
cnfg.Eigenfrequenz = 63.5*2*pi;         %Eigenfrequenz des Rotors in rad/sec.

% Instanzieren eines Objekts
KraftMonitor = BearingForceApproach('KraftMonitor');
KraftMonitor.cnfg=cnfg;

% Aufruf Berechnungsfunktionen
KraftMonitor.initialize(dataset);
KraftMonitor.revise(datasetNeu);
KraftMonitor.show;

%% Positionsmessung
% Parameter
cnfg.ModaleMasse1EO = 5.817;
cnfg.MasseRotorGesamt = 11.123;
cnfg.zPosUnwucht = 0.095;
cnfg.zPosSensor = 0.3050;
cnfg.Unwuchtmatrix = [0.59/2, 1.176e-6, 145*pi/180];
cnfg.GesamtUnwucht = 0;
ESF1_path = ['.\+AMrotorMONI\RotorConfiguration\','ESF1','.mat'];
load(ESF1_path);
ESF1.uESF1=uESF1;
ESF1.zESF1=zESF1;
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

% Parameter


%% Aufruf Berechungsfunktionen
%KombiMonitor.initialize;
%KombiMonitor.revise;
KombiMonitor.show;