
%% DemoB
% Zur Demonstration der AMrotorSIM-Toolbox

%% Header

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

Config_Sim_DemoB


%% Running system analysis
r=Rotorsystem(cnfg,'System');
r.show;

r.rotor.mesh();

g=Graphs.Visu_Rotorsystem(r);
g.show();

r.compute_matrices();


%% Running Time Simulation

m = Experiments.Modalanalyse(r);

m.calculate_rotorsystem(4,0:100:1000);
esf=Graphs.Eigenschwingformen(m);
esf.plot();
