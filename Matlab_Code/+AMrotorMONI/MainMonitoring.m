clear all
clc
import AMrotorMONI.*

% Test Datenpaket für Initialisierungslauf
data1800=['.\+AMrotorMONI\Configurations\','data1800','.mat'];
load(data1800)
dataset(1,:,:)=data;
data1900=['.\+AMrotorMONI\Configurations\','data1900','.mat'];
load(data1900)
dataset(2,:,:)=data;
data2000=['.\+AMrotorMONI\Configurations\','data2000','.mat'];
load(data2000)
dataset(3,:,:)=data;

% Test Datenpake für wiederholung des Monitorings
data200=['.\+AMrotorMONI\Configurations\','data200','.mat'];
load(data200)
datasetNeu(1,:,:)=data;
data300=['.\+AMrotorMONI\Configurations\','data300','.mat'];
load(data300)
datasetNeu(2,:,:)=data;
data400=['.\+AMrotorMONI\Configurations\','data400','.mat'];
load(data400)
datasetNeu(3,:,:)=data;




%--------------------------------------------------------------------------
% Lagerkrafmessung
%%  Implemeierug der Klasse
NAME='KraftMonitor';
KraftMonitor = BearingForceApproach(NAME);

%% Parameter
clear cnfg;
cnfg.Lagerabstand = 0.59;   %Abstand zwischen den beiden Auflagern in Meter
cnfg.Eigenfrequenz = 63.5*2*pi;       %Eigenfrequenz des Rotors in rad/sec.
% Ende Parameter, Übergabe Parameter an Klasse
KraftMonitor.cnfg=cnfg;

%% Aufruf Berechnungsfunktionen
KraftMonitor.initialize(dataset);
KraftMonitor.revise(datasetNeu);
KraftMonitor.show;



%--------------------------------------------------------------------------
% Positionsmessung
%% Implementierung der Klasse
NAME='PositionMonitor';
PosiMonitor = RotorHubApproach(NAME);

%% Parameter
clear cnfg;
cnfg.Eigenfrequenz = 63.5;
cnfg.ModaleMasse1EO = 5.817;
cnfg.MasseRotorGesamt = 11.123;
cnfg.Lagerabstand = 0.59;
cnfg.zPosUnwucht = 0.095;
cnfg.zPosSensor = 0.3050;
cnfg.Unwuchtmatrix = [0.59/2, 1.176e-6, 145*pi/180];
cnfg.GesamtUnwucht = 0;
ESF1 = ['.\+AMrotorMONI\Configurations\','ESF1','.mat'];
% Ende Parameter, Übergabe Parameter an Klasse
PosiMonitor.cnfg = cnfg;
PosiMonitor.ESF1 = ESF1;

%% Aufruf Berechnungsfunktionen
PosiMonitor.initialize(dataset);
PosiMonitor.revise(datasetNeu);
PosiMonitor.show;



%--------------------------------------------------------------------------
% Kombination Lagerkraft und Positionsmessung
%% Implementierung der Klasse
NAME = 'KombiniertesMonitoring';
KombiMonitor = CombinedForceHubApproach(NAME);

%% Parameter
clear cnfg;
% Ende Parameter, Übergabe Parameter an Klasse

%% Aufruf Berechungsfunktionen
%KombiMonitor.initialize;
%KombiMonitor.revise;
KombiMonitor.show;
