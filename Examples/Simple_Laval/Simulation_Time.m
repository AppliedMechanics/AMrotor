%% Simple Laval - Zeitintegration fuer FRF-Berechnung


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
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m

r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); 
% r.rotor.geometry.show_3D(); % funktioniert nicht richtig

% r.rotor.mesh.show_2D(); 
% r.rotor.mesh.show_2D_nodes(); 
%r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();


r.rotor.assemble_fem;

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg( r , 0 , (0:0.001:1) );%obj = Stationaere_Lsg(a,drehzahlvektor,time)
St_Lsg.compute_ode15s_ss;
%St_Lsg.compute_euler_ss
% St_Lsg.compute_newmark 
%St_Lsg.compute_sys_ss_variant
% St_Lsg.save_data('St_Lsg_Laval_U_fwd_bwd_sweep_0_2krpm');

% Hochlauf = Experiments.Hochlaufanalyse( r , [0, 1e3] , (0:0.001:0.5) ); % input: (rotorsystem, [rpm_start, rpm_end], time_vector)
% Hochlauf.compute_ode15s_ss

%% Plot results 
%------------- Erzeuge Ausgabeformat der Loesung ---------------

Lsg = St_Lsg; % Lsg = Hochlauf;

d = Dataoutput.TimeDataOutput(Lsg);
% d = Dataoutput.TimeDataOutput(Hochlauf);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'Hochlauf_Laval_U_x_sweep0_200Hz_3000rpm');


%------------- Erzeuge Grafiken aus Loesung -------------------

t = Graphs.TimeSignal(r, Lsg);
o = Graphs.Orbitdarstellung(r, Lsg);
f = Graphs.Fourierdarstellung(r, Lsg);
fo = Graphs.Fourierorbitdarstellung(r, Lsg);
w = Graphs.Waterfalldiagramm(r, Lsg);
w2 = Graphs.WaterfalldiagrammTwoSided(r, Lsg);

frf = Experiments.FrequenzgangfunktionTime(St_Lsg);
frf.calculate(r.sensors(6),r.sensors(5),0,'u_x','u_x',4);
visufrf = Graphs.Frequenzgangfunktion(frf);
visufrf.set_plots('bode','log','deg','coh')

 for sensor = r.sensors
          t.plot(sensor);
%          t.plot_Orbit(sensor);
%          o.plot(sensor);
%          f.plot(sensor);
%          fo.plot(sensor,1); % Error Curve Fitting Toolbox muss installiert sein
%          fo.plot(sensor,2);
%          w.plot(sensor); % Wasserfall
         w2.plot(sensor); % Wasserfall 2 Sided
          Janitor.cleanFigures();
 end
