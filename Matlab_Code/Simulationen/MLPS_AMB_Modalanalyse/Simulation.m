%% MLPS - AMB - Modalanalyse
% Zur Berechnung der Rohdaten für die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018

%% Import

import AMrotorSIM.*

Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);
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

%g=Graphs.Visu_Rotorsystem(r);
%g.show();

r.assemble_system_matrices();
r.assemble_system_loads();
r.transform_StateSpace;
%% Running system analyses

[masse, Jzz]= r.rotor.get_mass();
volume = r.rotor.geometry.get_volume();

r1=(4e-3);
r2=(69e-3);
vol1 = r1^2*pi*(695e-3);
vol2 = r2^2*pi*(11e-3);
vol = vol1+vol2;
mass1 = vol1*7446;
mass2 = vol2*7446;
mass=mass1+mass2;

I=0.5*mass1*r1^2 + 0.5*mass2*r2^2;

f = r.rotor.check_rigidbody();
sf=sum(f);

m=Experiments.Modalanalyse(r);

%m.calculate_rotor_only_without_damping(15);
%m.calculate_rotor_only(5,100);

m.calculate_rotorsystem_without_damping(15);
%m.calculate_rotorsystem(15,0);
%
esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
%Janitor.cleanFigures();
% 


%r.reduce_modal(10);

% m.calculate_rotorsystem(3);
% cmp = Graphs.Campbell(m);
% cmp.plot_displacements();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,1000,[0:0.01:0.5]);
St_Lsg.compute_ode15s_ss
%St_Lsg.show()
%St_Lsg.compute()
% 
% %------------- Erzeuge Ausgabeformat der Lösung ---------------
% 
% d = Dataoutput.TimeDataOutput(St_Lsg);
% dataset_monitoring = d.compose_data();
% 
% 
% %------------- Erzeuge Grafiken aus Lösung -------------------
% 
 t = Graphs.TimeSignal(r, St_Lsg);
% o = Graphs.Orbitdarstellung(r, St_Lsg);
% f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
% w = Graphs.Waterfalldiagramm(r, St_Lsg);
% 
 for sensor = r.sensors
          t.plot(sensor);
%          o.plot(sensor);
%          f.plot(sensor);
%          %fo.plot(sensor,1);
%          %fo.plot(sensor,2);
%          %w.plot(sensor);
%          Janitor.cleanFigures();
 end
