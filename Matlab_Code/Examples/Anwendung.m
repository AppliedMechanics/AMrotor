% Johannes Maierhofer
% 28.03.2017,29.03.2017,30.03.2017,31.03.2017,03.04.2017,04.04.2017

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

r.compute_matrices();
r.compute_loads();
%r.reduce_modal(10);

%r.sichern();

%% Running system analyses
%Modalanalyse(r).show()

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,50,0:1e-3:5);
St_Lsg.show()
St_Lsg.compute()

w = Graphs.Wegorbit(r);
w.plot(r.sensors(1:2));


