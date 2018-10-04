%% DPS
% Zur Berechnung der Rohdaten für die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018

%% Import

import AMrotorSIM.*

Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);
%% Clean up
close all
clear all
% clc

%% Compute Rotor

Config_Sim_DPS

r=Rotorsystem(cnfg,'DPS-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m

%r.rotor.geometry.show_2D(); % Darstellung des Innenradius hinzufuegen
%r.rotor.geometry.show_3D();

% r.rotor.mesh.show_2D(); 
%r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();


r.assemble_system_matrices();
%r.assemble_system_loads();
u_trans_rigid_body = r.compute_translational_rigid_body_modes;
overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)
r.transform_StateSpace;
r.transform_StateSpace_variant;
%% Running system analyses
% 
% m=Experiments.Modalanalyse(r);
% 
% m.calculate_rotor_only_without_damping(15);
% m.calculate_rotor_only(15,100);
% 
% m.calculate_rotorsystem_without_damping(15);
% % m.calculate_rotorsystem(15,0);
% 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% Janitor.cleanFigures();
% 
% 
% r.reduce_modal(10);
% 
% m.calculate_rotorsystem(3);
% cmp = Graphs.Campbell(m);
% cmp.plot_displacements();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,[0:25:10e3],[0:0.001:2]); %obj = Stationaere_Lsg(a,drehzahlvektor,time)
%St_Lsg.compute_ode15s_ss           %läuft leider immer noch nicht!
St_Lsg.compute_ode15s_ss_variant
%St_Lsg.compute_euler_ss
%St_Lsg.compute_newmark
%St_Lsg.compute_sys_ss_variant

% 
%------------- Erzeuge Ausgabeformat der Lösung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'Hochlauf_0_10krpm');
% save('workspace_temp.mat');
% 
% 
% %------------- Erzeuge Grafiken aus Lösung -------------------
% 
 t = Graphs.TimeSignal(r, St_Lsg);
o = Graphs.Orbitdarstellung(r, St_Lsg);
f = Graphs.Fourierdarstellung(r, St_Lsg);
fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
w = Graphs.Waterfalldiagramm(r, St_Lsg);
% 
 for sensor = r.sensors
%          t.plot(sensor);
%          t.plot_Orbit(sensor);
%          o.plot(sensor);
%          f.plot(sensor);
%          fo.plot(sensor,1); % Error Curve Fitting Toolbox muss installiert sein
%          fo.plot(sensor,2);
         w.plot(sensor); % Wasserfall
          Janitor.cleanFigures();
 end
