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

r.Rotor.FEMRotor.geometry.show_2D();

%% Bis hier funktioniert es schon!


mesh.plot_mesh_2d();
fe_model.assemble_fem();

%r.rotor.mesh()

g=Graphs.Visu_Rotorsystem(r);
g.show();

%r.compute_matrices();
%r.compute_loads();
%r.reduce_modal(10);

%% Running system analyses

m=Experiments.Modalanalyse(r);

% m.calculate_rotor_only(4,0:100:1000);
% esf = Graphs.Eigenschwingformen(m);
% esf.plot();

m.calculate_rotorsystem(4,0:100:1000);
esf2= Graphs.Eigenschwingformen(m);
esf2.plot();

m.calculate_rotorsystem(3,0:100:3000);
cmp = Graphs.Campbell(m);
cmp.plot();

%% Running Time Simulation

 St_Lsg = Experiments.Stationaere_Lsg(r,1000,[0 2]);
 St_Lsg.show()
 St_Lsg.compute()

 w = Graphs.Wegorbit(r);
 w.plot(r.sensors);
