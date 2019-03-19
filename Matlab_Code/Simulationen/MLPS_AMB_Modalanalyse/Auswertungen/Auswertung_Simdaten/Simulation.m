%% MLPS - AMB - Modalanalyse
% Zur Berechnung der Rohdaten f�r die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
% clc
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

% Config_Sim
Config_Sim_symm
% Config_Sim_Scheiben
% Config_Sim_Scheiben_symm
% Config_Sim_Laval

r=Rotorsystem(cnfg,'MLPS-System');
r.assemble;
r.show;

% r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); 
% r.rotor.geometry.show_3D(); % funktioniert nicht richtig

% r.rotor.mesh.show_2D(); % show elements
% r.rotor.mesh.show_2D_nodes(); % show geo_nodes
% r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();

 r.rotor.assemble_fem;
  
u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)
nEle = length(r.rotor.mesh.elements)

% write_sensors_for_abravibe(r,0,'MLPS_abravibe_simdata_mck');
% return

% save r

%% Running system analyses
% 
% m=Experiments.Modalanalyse(r);
% 
% %m.calculate_rotor_only_without_damping(15);
% %m.calculate_rotor_only(15,100);
% 
% %m.calculate_rotorsystem_without_damping(7);
% m.calculate_rotorsystem(18,0);
% 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% Janitor.cleanFigures();
% 
% % create MAC matrix (using abravibe toolbox)
% % modesToCompare = [3,5,7,10,12,14,17];%[3,5,7,10,12];%
% % p = m.eigenValues.lateral(modesToCompare);
% % V = m.eigenVectors.Sensor.lat_x(:,modesToCompare);
% % MAC=amac(V); % auto-MAC
% % figure
% % plotmac(MAC,p);
% % 
% % return
% 
% cmp = Experiments.Campbell(r);
% cmp.set_up(0:2e2:10e3,10); % input is 1/min, Number of Modes
% cmp.calculate();
% cmpDiagramm = Graphs.Campbell(cmp);
% cmpDiagramm.print_critical_speeds()
% cmpDiagramm.set_plots('all');
% % cmpDiagramm.set_plots('backward');
% % cmpDiagramm.set_plots('forward');
% % esf.set_plots('half') % 'all', 'half' or desired mode number
% % esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
% Janitor.cleanFigures();
% return

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,00,[0:0.001:10]);
%St_Lsg.compute_ode15s_ss           %l�uft leider immer noch nicht!
St_Lsg.compute_ode15s_ss_variant
%St_Lsg.compute_euler_ss
%St_Lsg.compute_newmark
%St_Lsg.compute_sys_ss_variant

% 
%------------- Erzeuge Ausgabeformat der L�sung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'noise250HzML1x_10s_1kHz');%'sweepx_0-300Hz_dm_AnregungLager2_4s-1kHz');
% 
% 
% %------------- Erzeuge Grafiken aus L�sung -------------------
% 
 t = Graphs.TimeSignal(r, St_Lsg);
% o = Graphs.Orbitdarstellung(r, St_Lsg);
% f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
% w = Graphs.Waterfalldiagramm(r, St_Lsg);
w2 = Graphs.WaterfalldiagrammTwoSided(r, St_Lsg);
% 
 for sensor = r.sensors
          t.plot(sensor);
%          o.plot(sensor);
%          f.plot(sensor);
%          %fo.plot(sensor,1);
%          %fo.plot(sensor,2);
%          %w.plot(sensor);
          w2.plot(sensor); % Wasserfall 2 Sided
         Janitor.cleanFigures();
 end