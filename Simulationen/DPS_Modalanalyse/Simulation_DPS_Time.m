%% DPS - Zeitintegration
% laeuft nicht bzw. sehr langsam

%% Clean up
close all
clear all
% clc
%% Import

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

Config_Sim_DPS_Time

r=Rotorsystem(cnfg,'DPS-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m

r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); % Darstellung des Innenradius hinzufuegen
%r.rotor.geometry.show_3D();

% r.rotor.mesh.show_2D(); 
%r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();


r.rotor.assemble_fem;

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg( r , 1e3 , (0:0.001:0.01) );%St_Lsg = Experiments.Stationaere_Lsg(r,[0:50:10e3],[0:0.001:2]); %obj = Stationaere_Lsg(a,drehzahlvektor,time)
% St_Lsg = Experiments.Stationaere_Lsg_nonlinear(r,1000,0:0.001:1);
St_Lsg.compute_ode15s_ss

% Hochlauf = Experiments.Hochlaufanalyse( r , [0, 80e3] , (0:0.01:10) ); % input: (rotorsystem, [rpm_start, rpm_end], time_vector)
% Hochlauf.compute_ode15s_ss

%% Plot results 
%------------- Erzeuge Ausgabeformat der Loesung ---------------

% d = Dataoutput.TimeDataOutput(St_Lsg);
% dataset_modalanalysis = d.compose_data();
% d.save_data(dataset_modalanalysis,'Hochlauf_DPS_U_fwd_bwd_sweep_0_12krpm');
%Methode um die Daten einfach laden zu koennen?
% save('workspace_temp.mat');
% 
% 
% %------------- Erzeuge Grafiken aus Loesung -------------------
% 
t = Graphs.TimeSignal(r, St_Lsg);
o = Graphs.Orbitdarstellung(r, St_Lsg);
f = Graphs.Fourierdarstellung(r, St_Lsg);
fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
w = Graphs.Waterfalldiagramm(r, St_Lsg);
w2 = Graphs.WaterfalldiagrammTwoSided(r, St_Lsg);

% t = Graphs.TimeSignal(r, Hochlauf);
% o = Graphs.Orbitdarstellung(r, Hochlauf);
% f = Graphs.Fourierdarstellung(r, Hochlauf);
% fo = Graphs.Fourierorbitdarstellung(r, Hochlauf);
% w = Graphs.Waterfalldiagramm(r, Hochlauf);
% 
 for sensor = r.sensors
          t.plot(sensor);
%          t.plot_Orbit(sensor);
%          o.plot(sensor);
         f.plot(sensor);
%          fo.plot(sensor,1); % Error Curve Fitting Toolbox muss installiert sein
%          fo.plot(sensor,2);
%          w.plot(sensor); % Wasserfall
         w2.plot(sensor); % Wasserfall 2 Sided
          Janitor.cleanFigures();
 end
