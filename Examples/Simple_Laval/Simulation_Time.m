% Simple Laval - Time integration for FRF calculation

%% Clean up

close all
clear all
% clc
%% Import
%% Import and formating of the figures

import AMrotorSIM.* % path
Config_Sim_Time % corresponding cnfg-file

Janitor = AMrotorTools.PlotJanitor(); % Instantiation of class PlotJanitor
Janitor.setLayout(2,3); %Setting layout of the figures

%% Compute Rotor
%% Assembly of the rotordynamic model

r=Rotorsystem(cnfg,'Laval-Rotor'); % Instantiation of class Rotorsystem
r.assemble; % Assembly of the model parts, considering the ...
            % components (sensors,..) from the cnfg-file
r.rotor.assemble_fem; % Assembly of the global system matrices: M, D, G, K

%% Visualization of the assembled rotor model

r.show; % lists the associated components of the model in teh Matlab ...
        % Command Window
        
r.rotor.show_2D(); % Plot of a side view of the rotor elements
% r.rotor.geometry.show_2D();  % Plot of a side view of the ..
                               % rotor radii
% r.rotor.geometry.show_3D(); % Plot of a 3D-isometry of the rotor
% r.rotor.mesh.show_2D(); 
% r.rotor.mesh.show_2D_nodes(); 
% r.rotor.mesh.show_3D();

g=Graphs.Visu_Rotorsystem(r); % Instantiation of class Visu_Rotorsystem
g.show(); % Plot of a 3D-isometry of the rotor with sensors, loads,...

%% Running Time Simulation
%% Running Time Simulation
%% Stationary with avaliable calculation methods

St_Lsg = Experiments.Stationaere_Lsg(r,[1000,1200],(0:0.001:0.02)); % In...
    %stantiation of class Stationaere_Lsg
    
% options.adapt=true; options.locTolUpper=1e-3; 
% options.locTolLower=1e-4; options.globTol=1;

% St_Lsg.compute_ode15s_ss; % ode15s - method
% St_Lsg.compute_euler_ss; % Forward euler - method (in progress)
% St_Lsg.compute_newmark; % newmark - method
% St_Lsg.compute_newmark(options); % newmark - method with options
% St_Lsg.compute_sys_ss_variant; (in progress)

% St_Lsg.save_data('St_Lsg_Laval_U_fwd_bwd_sweep_0_2krpm');

%% Run up with avaliable calculation methods

% Runup = Experiments.Hochlaufanalyse(r,[0,1e3],(0:0.001:0.5)); % In...
    %stantiation of class Stationaere_Lsg
    
% Runup.compute_ode15s_ss; % ode15s - method

%% FRF over time

% frf = Experiments.FrequenzgangfunktionTime(St_Lsg); % Instantiation ...
                                        % of class FrequenzgangfunktionTime

% frf.calculate(r.sensors(6),r.sensors(5),0,'u_x','u_x',4,'boxcar');??????????

%% Plot results
%% Processing and visualization of the results

d = Dataoutput.TimeDataOutput(St_Lsg); % Instantiation of class ...
                                       % TimeDataOutput
% d = Dataoutput.TimeDataOutput(Runup);

%% Processing and saving results

dataset_modalanalysis = d.compose_data(); % container: rpm -> 
                                          % (n,t,allsensorsxy)
d.save_data(dataset_modalanalysis,'Hochlauf_Laval_U_x_sweep0_200Hz_3000rpm'); 
dataset_modalanalysis = d.compose_data_sensor_wise(); % container: rpm -> 
                                                      % (sensor1,sensor2,.)
struct = d.convert_data_to_struct_sensor_wise(dataset_modalanalysis);
d.save_data(struct,'Hochlauf_Laval_U_x_sweep0_200Hz_3000rpm');

%% Visualizing results

Lsg=St_Lsg;
t = Graphs.TimeSignal(r, Lsg); % Instantiation of class TimeSignal
o = Graphs.Orbitdarstellung(r, Lsg); % Instantiation of class ...
                                     % Orbitdarstellung
f = Graphs.Fourierdarstellung(r, Lsg); % Instantiation of class ...
                                       % Fourierdarstellung
fo = Graphs.Fourierorbitdarstellung(r, Lsg); % Instantiation of class ...
                                             % Fourierorbitdarstellung
w = Graphs.Waterfalldiagramm(r, Lsg); % Instantiation of class ...
                                      % Waterfalldiagramm
w2 = Graphs.WaterfalldiagrammTwoSided(r, Lsg); % Instantiation of class ...
                                               % WaterfalldiagrammTwoSided

% visufrf = Graphs.Frequenzgangfunktion(frf);?????????????????
% visufrf.set_plots('bode','log','deg','coh');

 for sensor = r.sensors % Loop over all sensors for plotting
          t.plot(sensor,[1,2,3]); % Time signal
          o.plot(sensor); % Orbits
          f.plot(sensor); % Fourier
          fo.plot(sensor,1); % Fourierorbit 1st order
          fo.plot(sensor,2); % Fourierorbit 2nd order
          w.plot(sensor); % Waterfall
          w2.plot(sensor); % Waterfall 2sided
          Janitor.cleanFigures();
 end
