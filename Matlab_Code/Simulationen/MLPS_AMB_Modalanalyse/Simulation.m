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
r.transform_StateSpace_variant;
%% Running system analyses

%m=Experiments.Modalanalyse(r);

%m.calculate_rotor_only_without_damping(15);
%m.calculate_rotor_only(15,100);

%m.calculate_rotorsystem_without_damping(15);
%m.calculate_rotorsystem(15,0);
%
%esf= Graphs.Eigenschwingformen(m);
%esf.print_frequencies();
%esf.plot_displacements();
%Janitor.cleanFigures();
% 

%r.reduce_modal(10);

% m.calculate_rotorsystem(3);
% cmp = Graphs.Campbell(m);
% cmp.plot_displacements();

%% Statische Durchbiegung des Systems (im StateSpace)

% ss_B = r.systemmatrices.ss_B;
% h_ges=sparse(2040,1);
% h_ges(601)=1;
% 
% u=ss_B\h_ges;
% u_x=u(1:6:end/2);
% psi_y=u(5:6:end/2);
% 
% figure()
% plot(u_x)
% figure()
% plot(psi_y)

%% Statische Lösung in dynamisches Problem einsetzen:
% ss_A = r.systemmatrices.ss_A;
% Z=u;
% 
% dZ = -(ss_A\ss_B)*Z+ss_A\h_ges;
% 
% u_ddx=dZ(end/2+1:6:end);
% psi_ddy=dZ(end/2+5:6:end);
% 
% figure()
% plot(u_ddx)
% figure()
% plot(psi_ddy)


%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,0,[0:0.001:0.5]);
%St_Lsg.compute_ode15s_ss
%St_Lsg.compute_euler_ss
St_Lsg.compute_newmark

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
