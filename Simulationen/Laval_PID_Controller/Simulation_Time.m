%% Laval_PID_Controller - Zeitintegration
% Laval rotor from Simple_Laval with pid-controller for the disc to
% demonstrate the functionality of the pidController-class

%% Clean up
close all
clear all
% clc

%% Import
import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor
Config_Sim_Time

r=Rotorsystem(cnfg,'Laval-Rotor');
r.assemble;
r.show;

r.rotor.show_2D();

g=Graphs.Visu_Rotorsystem(r);
g.show();


r.rotor.assemble_fem;

%% Running Time Simulation
St_Lsg = Experiments.Stationaere_Lsg( r , 0 , (0:0.001:0.2) );
St_Lsg.compute_ode15s_ss
% St_Lsg.compute_newmark

% Hochlauf = Experiments.Hochlaufanalyse( r , [0, 1e3] , (0:0.001:0.2) );
% Hochlauf.compute_ode15s_ss

%% Plot results 
Lsg = St_Lsg; % Lsg = Hochlauf;
d = Dataoutput.TimeDataOutput(Lsg);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'Hochlauf_Regelung');

t = Graphs.TimeSignal(r, Lsg);
 for sensor = r.sensors
          t.plot(sensor);
          Janitor.cleanFigures();
 end
