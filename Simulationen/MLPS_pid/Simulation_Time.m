%% Laval_PID_Controller - Zeitintegration
% Laval rotor from Simple_Laval with pid-controller for the disc to
% demonstrate the functionality of the pidController-class

%% Clean up
close all
clear all
% clc
%% Import
%% Import and formating of the figures

import AMrotorSIM.* % path
Config_Sim_MLPS % corresponding cnfg-file
Janitor = AMrotorTools.PlotJanitor(); % Instantiation of class PlotJanitor
Janitor.setLayout(2,3); %Setting layout of the figures

%% Compute Rotor
%% Assembly of the rotordynamic model

r=Rotorsystem(cnfg, ... 
'MBTR-Rotor with PID-Controller and negative stiffness for the AMBs');
        % Instantiation of class Rotorsystem
r.assemble; % Assembly of the model parts, considering the ...
            % components (sensors,..) from the cnfg-file
r.rotor.assemble_fem; % Assembly of the global system matrices: M, D, G, K

%% Visualization of the assembled rotor model

r.show; % lists the associated components of the model in teh Matlab ...
        % Command Window

r.rotor.show_2D(); % Plot of a side view of the rotor elements

g=Graphs.Visu_Rotorsystem(r); % Instantiation of class Visu_Rotorsystem
g.show(); % Plot of a 3D-isometry of the rotor with sensors, loads,...

%% Running Time Simulation
%% Running Time Simulation
%% Stationary and runup with avaliable calculation methods and visualization
% St_Lsg = Experiments.Stationaere_Lsg(r,0,(0:0.001:1)); % In...
    %stantiation of class Stationaere_Lsg (Stationary solution)
    
% St_Lsg.compute_ode15s_ss; % ode15s - method
% St_Lsg.compute_newmark; % newmark - method

Runup = Experiments.Hochlaufanalyse(r,[0,1e3],(0:0.001:0.2)); % In...
    %stantiation of class Hochlaufanalyse (Runup)
Runup.compute_ode15s_ss % ode15s - method

%% Processing and visualization of the results

d = Dataoutput.TimeDataOutput(Runup); % Instantiation of class ...
                                       % TimeDataOutput

%% Processing and saving results

% dataset = d.compose_data(); % container: rpm -> 
                                          % (n,t,allsensorsxy)
dataset = d.compose_data_sensor_wise();
datasetName = 'MLPS_pid_5s';
d.save_data(dataset,datasetName);
struct = d.convert_data_to_struct_sensor_wise(dataset);
d.save_data(struct,datasetName);
d.write_data_to_unv(datasetName);

%% Visualizing results

Lsg = St_Lsg; 
% Lsg = Runup;

t = Graphs.TimeSignal(r, Lsg); % Instantiation of class TimeSignal
f = Graphs.Fourierdarstellung(r, Lsg); % Instantiation of class ...
                                       % Fourierdarstellung
 for sensor = r.sensors
          t.plot(sensor); % Time signal
          f.plot(sensor); % Fourier
          Janitor.cleanFigures();
 end
