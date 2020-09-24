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
% Config_Sim_Time_LavalPID
Config_Sim_MLPS


r=Rotorsystem(cnfg,'MLPS-Rotor mit PID-Regelung und negativer Steifigkeit fuer Magnetlager');
r.assemble;
r.show;

r.rotor.show_2D();

g=Graphs.Visu_Rotorsystem(r);
g.show();


r.rotor.assemble_fem;

%% Running Time Simulation
St_Lsg = Experiments.Stationaere_Lsg( r ,0 , (0:0.001:1) );
St_Lsg.compute_ode15s_ss
% St_Lsg.compute_newmark

% Hochlauf = Experiments.Hochlaufanalyse( r , [0, 1e3] , (0:0.001:0.2) );
% Hochlauf.compute_ode15s_ss

%% Plot results 
Lsg = St_Lsg; % Lsg = Hochlauf;
d = Dataoutput.TimeDataOutput(St_Lsg);
% dataset_modalanalysis = d.compose_data();
dataset_modalanalysis = d.compose_data_sensor_wise();
datasetName = 'MLPS_pid_5s';
d.save_data(dataset_modalanalysis,datasetName);
struct = d.convert_data_to_struct_sensor_wise(dataset_modalanalysis);
d.save_data(struct,datasetName);
d.write_data_to_unv(datasetName)

t = Graphs.TimeSignal(r, Lsg);
w = Graphs.WaterfalldiagrammTwoSided(r, Lsg);
 for sensor = r.sensors
          t.plot(sensor);
%           w.plot(sensor);
          Janitor.cleanFigures();
 end
