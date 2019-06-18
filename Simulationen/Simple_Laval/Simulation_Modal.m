%% Simple Laval - Modalanalyse


%% Clean up
close all
clear all
% clc
%% Import

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

Config_Sim_Modal

r=Rotorsystem(cnfg,'Laval-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m


r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); 
% r.rotor.geometry.show_3D(); % funktioniert nicht richtig

% r.rotor.mesh.show_2D(); 
% r.rotor.mesh.show_2D_nodes(); 
%r.rotor.mesh.show_3D();

g=Graphs.Visu_Rotorsystem(r);
g.show();


r.rotor.assemble_fem;

% u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)


%% Running system analyses

% Modalanalyse
m=Experiments.Modalanalyse(r);

m.calculate_rotorsystem(10,0e3);

esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
esf.set_plots('half') % 'all', 'half' or desired mode number
%esf.set_plots('half','overlay')
% esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
Janitor.cleanFigures();


% Campbell-Diagramm
cmp = Experiments.Campbell(r);
cmp.set_up(1e2:1e2:10e3,8); 
cmp.calculate();% input of set_up is (1/min, Number of Modes)
cmpDiagramm = Graphs.Campbell(cmp);
cmpDiagramm.print_damping_zero_crossing();
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
Janitor.cleanFigures();

% % to plot the Campbell-Diagram from the simulation into the waterfalldiagram from the experiment
% plot_Campbell_stem3(cmpDiagramm,1e-3)
% plot_Campbell_plot(cmpDiagramm)
