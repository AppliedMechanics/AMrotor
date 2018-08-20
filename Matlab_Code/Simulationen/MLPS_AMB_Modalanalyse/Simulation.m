%% MLPS - AMB - Modalanalyse
% Zur Berechnung der Rohdaten für die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
clc

%% Compute Rotor

Config_Sim

r=Rotorsystem(cnfg,'MLPS-System');
r.assemble;
r.show;

%r.rotor.geometry.show_2D();
%r.rotor.geometry.show_3D();

%r.rotor.mesh.show_2D(); 
%r.rotor.mesh.show_3D();

g=Graphs.Visu_Rotorsystem(r);
g.show();

r.assemble_system_matrices();
r.transform_StateSpace;
%% Running system analyses

m=Experiments.Modalanalyse(r);

m.calculate_rotor_only_without_damping(15);
%m.calculate_rotor_only(5,100);

%m.calculate_rotorsystem_without_damping(15);
%m.calculate_rotorsystem(15,0);
%
esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
% 

%r.compute_loads();
%r.reduce_modal(10);

% m.calculate_rotorsystem(3);
% cmp = Graphs.Campbell(m);
% cmp.plot_displacements();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,1000,[0 0.1]);
St_Lsg.compute_ode15s_ss
%St_Lsg.show()
%St_Lsg.compute()
% 
w = Graphs.Wegorbit(r);
w.plot(r.sensors);
