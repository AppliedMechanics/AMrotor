%% Tutorialanwendung
% Zur Demonstration der AMrotorSIM-Toolbox

%% Header

% Johannes Maierhofer
% 29.06.2018
%
%         .o.       ooo        ooooo                        .                      
%        .888.      `88.       .888'                      .o8                      
%       .8"888.      888b     d'888  oooo d8b  .ooooo.  .o888oo  .ooooo.  oooo d8b 
%      .8' `888.     8 Y88. .P  888  `888""8P d88' `88b   888   d88' `88b `888""8P 
%     .88ooo8888.    8  `888'   888   888     888   888   888   888   888  888     
%    .8'     `888.   8    Y     888   888     888   888   888 . 888   888  888     
%   o88o     o8888o o8o        o888o d888b    `Y8bod8P'   "888" `Y8bod8P' d888b    

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
clc

%% Compute Rotor

doc_Tutorial_Example1_Config_Sim

r=Rotorsystem(cnfg,'System');
r.assemble;
r.show;

%r.rotor.geometry.show_2D();
%r.rotor.geometry.show_3D();

%r.rotor.mesh.show_2D(); 
%r.rotor.mesh.show_3D();

%g=Graphs.Visu_Rotorsystem(r);
%g.show();

r.assemble_system_matrices();
r.transform_StateSpace;
%% Running system analyses

m=Experiments.Modalanalyse(r);
m.rotorsystem.transform_StateSpace
%m.calculate_rotor_only_without_damping(15);

%m.calculate_rotor_only(5,100);

%m.calculate_rotorsystem_without_damping(15);
%m.calculate_rotorsystem(15,0);
%
%esf= Graphs.Eigenschwingformen(m);
%esf.print_frequencies();
%esf.plot_displacements();
% 

%% Erstmal bis hierher
%r.compute_loads();
%r.reduce_modal(10);

% m.calculate_rotorsystem(3);
% cmp = Graphs.Campbell(m);
% cmp.plot_displacements();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,1000,[0 0.1]);
St_Lsg.compute_ode15s_ss
St_Lsg.show()
%St_Lsg.compute()
% 
%w = Graphs.Wegorbit(r);
%w.plot(r.sensors);
