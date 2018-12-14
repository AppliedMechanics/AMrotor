%% DPS - Modalanalyse


%% Clean up
close all
clear all
% clc
%% Import

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

Config_Sim_DPS_Modal

r=Rotorsystem(cnfg,'DPS-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m

%r.rotor.geometry.show_2D(); % Darstellung des Innenradius hinzufuegen
%r.rotor.geometry.show_3D();

% r.rotor.mesh.show_2D(); 
%r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();


r.rotor.assemble_fem;

% u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)


%% Running system analyses

% % Modalanalyse
% m=Experiments.Modalanalyse(r);
% 
% m.calculate_rotorsystem(20,10e3);
% 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% % esf.set_plots('half') % 'all', 'half' or desired mode number
% %esf.set_plots('half','overlay')
% % esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
% Janitor.cleanFigures();


% Campbell-Diagramm
cmp = Experiments.Campbell(r);
cmp.set_up(0:2e2:20e3,8); 
cmp.calculate();% input of set_up is (1/min, Number of Modes)
cmpDiagramm = Graphs.Campbell(cmp);
cmpDiagramm.print_damping_zero_crossing()
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
Janitor.cleanFigures();
