%% DPS
% Zur Berechnung der Rohdaten fuer die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018


%% Clean up
close all
clear all
% clc
%% Import

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

% Config_Sim_DPS
% Config_Sim_Laval_Dichtung
% Config_Sim_Laval_free
% Config_Sim_Laval_LimSingh
% Config_Sim_Laval_Muszynska
Config_Sim_DPS_Time

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

% m=Experiments.Modalanalyse(r);
% % 
% % m.calculate_rotor_only_without_damping(15);
% % m.calculate_rotor_only(15,100);
% % 
% % m.calculate_rotorsystem_without_damping(15);
% m.calculate_rotorsystem(20,10e3);
% % 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% % esf.set_plots('half') % 'all', 'half' or desired mode number
% %esf.set_plots('half','overlay')
% % esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
% Janitor.cleanFigures();
% 
% 
% r.reduce_modal(10);
% 
% cmp = Experiments.Campbell(r);
% cmp.set_up(0:2e2:80e3,8); 
% cmp.calculate();% input of set_up is (1/min, Number of Modes)
% cmpDiagramm = Graphs.Campbell(cmp);
% % cmpDiagramm.print_damping_zero_crossing()
% % cmpDiagramm.print_critical_speeds()
% cmpDiagramm.set_plots('all');
% % cmpDiagramm.set_plots('backward');
% % cmpDiagramm.set_plots('forward');
% Janitor.cleanFigures();
% 
% return %stop execution -> Time integration is not yet functional

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg( r , 1e3 , (0:0.001:1) );%St_Lsg = Experiments.Stationaere_Lsg(r,[0:50:10e3],[0:0.001:2]); %obj = Stationaere_Lsg(a,drehzahlvektor,time)
%St_Lsg.compute_ode15s_ss           %laeuft leider immer noch nicht!
St_Lsg.compute_ode15s_ss_variant
%St_Lsg.compute_euler_ss
% St_Lsg.compute_newmark % Instabil, wenn LimSinghBearing als Load eingebunden ist und keine sehr feine Zeitdiskretisierung gewaehlt wurde.
%St_Lsg.compute_sys_ss_variant

Hochlauf = Experiments.Hochlaufanalyse( r , [0, 80e3] , (0:0.01:10) ); % input: (rotorsystem, [rpm_start, rpm_end], time_vector)
% Hochlauf.compute_ode15s_ss_variant

% 
%------------- Erzeuge Ausgabeformat der Loesung ---------------

% d = Dataoutput.TimeDataOutput(St_Lsg);
% dataset_modalanalysis = d.compose_data();
% d.save_data(dataset_modalanalysis,'Hochlauf_0_10krpm');
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

% t = Graphs.TimeSignal(r, Hochlauf);
% o = Graphs.Orbitdarstellung(r, Hochlauf);
% f = Graphs.Fourierdarstellung(r, Hochlauf);
% fo = Graphs.Fourierorbitdarstellung(r, Hochlauf);
% w = Graphs.Waterfalldiagramm(r, Hochlauf);
% 
 for sensor = r.sensors
         t.plot(sensor);
         t.plot_Orbit(sensor);
%          o.plot(sensor);
         f.plot(sensor);
%          fo.plot(sensor,1); % Error Curve Fitting Toolbox muss installiert sein
%          fo.plot(sensor,2);
%          w.plot(sensor); % Wasserfall
          Janitor.cleanFigures();
 end
