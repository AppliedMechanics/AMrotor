% Johannes Maierhofer
% 28.03.2017,29.03.2017,30.03.2017,31.03.2017,03.04.2017,04.04.2017
%
%      .o.       ooo        ooooo                        .                      
%     .888.      `88.       .888'                      .o8                      
%    .8"888.      888b     d'888  oooo d8b  .ooooo.  .o888oo  .ooooo.  oooo d8b 
%   .8' `888.     8 Y88. .P  888  `888""8P d88' `88b   888   d88' `88b `888""8P 
%  .88ooo8888.    8  `888'   888   888     888   888   888   888   888  888     
% .8'     `888.   8    Y     888   888     888   888   888 . 888   888  888     
%o88o     o8888o o8o        o888o d888b    `Y8bod8P'   "888" `Y8bod8P' d888b    
                                                                               
%%
%import AMrotorMONI.*
import AMrotorSIM.*


%% Clean up
close all
clear all
clc
%%

Config_Sim

r=Rotorsystem(cnfg,'System');
r.show;

r.rotor.mesh()
%g=Graphs.Visu_Rotorgeometrie(r.rotor);
%g.show();

g=Graphs.Visu_Rotorsystem(r);
g.show();

% r.compute_matrices();
% r.compute_loads();
% r.reduce_modal(10);

%r.sichern();

%% Running system analyses
%Modalanalyse(r).show()

%% Running Time Simulation

% St_Lsg = Experiments.Stationaere_Lsg(r,100,0:1e-3:1);
% St_Lsg.show()
% St_Lsg.compute()
% 
% w = Graphs.Wegorbit(r);
% w.plot(r.sensors(1:2));


