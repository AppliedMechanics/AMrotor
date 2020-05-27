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

Config_Sim_Modal_orthotropic_bearings

r=Rotorsystem(cnfg,'Laval-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m


r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); % show user input
r.rotor.geometry.show_3D(); % show user input 3D, does not show last section

% r.rotor.mesh.show_2D(); % show generated elements
% r.rotor.mesh.show_2D_nodes(); % show nodes and corresponding inner/outer radius
% r.rotor.mesh.show_3D(); % show 3D rotor with mesh


g=Graphs.Visu_Rotorsystem(r);
g.show(); % 3D rotor system with components


r.rotor.assemble_fem; % assemble structure matrices

u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)


%% Running system analyses
% Frequenzgangfunktion
frf=Experiments.Frequenzgangfunktion(r,'disc driving point');
type = 'd'; %type:'d','v','a'
inPos = 250e-3;%[100:100:500]*1e-3;%
outPos = 250e-3;%[100,250]*1e-3;%
f = 1:0.5:1000;
rpm = 0;
[f,H]=frf.calculate(f,inPos,outPos,type,rpm,{'u_x'},{'u_x'});%{'u_x','u_y','psi_x'},{'u_x','psi_x'});
[deltaIn,deltaOut]=frf.print_distance_delta;

visufrf = Graphs.Frequenzgangfunktion(frf);
% visufrf.set_plots('amplitude','db')
% visufrf.set_plots('phase','db')
visufrf.set_plots('bode','log','deg')
% visufrf.set_plots('nyquist')
Janitor.cleanFigures();

% Modalanalyse
m=Experiments.Modalanalyse(r);

m.calculate_rotorsystem(10,0e3); %(#modes,rpm)

esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();%esf.plot_displacements('complex');% to also check imaginary part
esf.set_plots('half') % 'all', 'half' or desired mode number
%esf.set_plots('half','overlay')
% esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
Janitor.cleanFigures();

% return

% Campbell-Diagramm
cmp = Experiments.Campbell(r);
cmp.set_up(1e2:1e2:10e3,6);%8); 
cmp.calculate();% input of set_up is (1/min, Number of Modes)
cmpDiagramm = Graphs.Campbell(cmp);
cmpDiagramm.print_damping_zero_crossing();
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
Janitor.cleanFigures();
