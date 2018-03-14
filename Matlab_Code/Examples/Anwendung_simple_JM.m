%% Datum der Änderungen
% 14.03.2018

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

Config_Sim_simple_JM

r=Rotorsystem(cnfg,'Simple_System');
r.show;

r.rotor.mesh();

%g=Graphs.Visu_Rotorsystem(r);
%g.show();                       
%Janitor.cleanFigures();

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

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,[250],[0:0.001:0.1]);
St_Lsg.show()
St_Lsg.compute_ode15s_ss

%------------- Erzeuge Grafiken aus Lösung -------------------

t = Graphs.TimeSignal(r, St_Lsg);
o = Graphs.Orbitdarstellung(r, St_Lsg);

for sensor = r.sensors
         t.plot(sensor);
         o.plot(sensor);
         Janitor.cleanFigures();
end