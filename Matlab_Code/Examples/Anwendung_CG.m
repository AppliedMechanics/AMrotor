%% Header

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

%% Datum der Änderungen
% 04.09.2017

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
clc
Timer = AMrotorTools.Timer();
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);
%% Compute Rotor

Config_Sim_CG

r=Rotorsystem(cnfg,'System');
r.show;

r.rotor.mesh();

g=Graphs.Visu_Rotorsystem(r);
g.show();                       %Hier scheint ein Bug für die Darstellung der Unwucht zu sein!
Janitor.cleanFigures();

r.compute_matrices();
r.compute_loads();

r.transform_StateSpace();


%% Running system analyses

% Mod=Experiments.Modalanalyse(r);
% Mod.calculate_rotorsystem(5);
% 
% esf2= Graphs.Eigenschwingformen(Mod);
% esf2.plot_displacements();
% Janitor.cleanFigures();

% Der Campbell-plot müsste im Prinzip komplett neu aufgebaut werden:

% cmp = Experiments.Campbell(r);
% cmp.setUp(0:2e2:1e3,8); % input is 1/min, Number of Modes
% cmp.calculate();
% 
% cmpDiagramm = Graphs.Campbell(cmp);
% cmpDiagramm.setPlots('all');
% cmpDiagramm.setPlots('backward');
% cmpDiagramm.setPlots('forward');
% Janitor.cleanFigures();
% Janitor.printFigures('Test',1);

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,[500,1000],[0:0.001:0.1]);
St_Lsg.show()
% St_Lsg.compute()
% St_Lsg.compute_newmark()
St_Lsg.compute_ode15s_ss

%------------- Erzeuge Ausgabeformat der Lösung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_monitoring = d.compose_data();


%------------- Erzeuge Grafiken aus Lösung -------------------

t = Graphs.TimeSignal(r, St_Lsg);
% o = Graphs.Orbitdarstellung(r, St_Lsg);
% f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
% w = Graphs.Waterfalldiagramm(r, St_Lsg);

for sensor = r.sensors
         t.plot(sensor);
%          o.plot(sensor);
%          f.plot(sensor);
%          fo.plot(sensor,1);
%          w.plot(sensor);
end
Janitor.cleanFigures();
   
