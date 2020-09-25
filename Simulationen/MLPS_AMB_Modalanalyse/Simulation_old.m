%% MBTR - AMB - Modal analyis

%% Clean up

close all
clear all
%clc
%% Import
%% Import and formating of the figures

import AMrotorSIM.* % path
Config_Sim_eingebaut % corresponding cnfg-file

Janitor = AMrotorTools.PlotJanitor(); % Instantiation of class PlotJanitor
Janitor.setLayout(2,3); %Setting layout of the figures

%% Compute Rotor
%% Assembly of the rotordynamic model

r=Rotorsystem(cnfg,'MBTR-TestRig'); % Instantiation of class Rotorsystem
r.assemble; % Assembly of the model parts, considering the ...
            % components (sensors,..) from the cnfg-file
r.rotor.assemble_fem; % Assembly of the global system matrices: M, D, G, K

%% Visualization of the assembled rotor model

r.show; % lists the associated components of the model in teh Matlab ...
        % Command Window

r.rotor.show_2D(); % Plot of a side view of the rotor elements
% r.rotor.geometry.show_2D();  % Plot of a side view of the ..
                               % rotor radii
% r.rotor.geometry.show_3D(); % Plot of a 3D-isometry of the rotor
% r.rotor.mesh.show_2D(); 
% r.rotor.mesh.show_2D_nodes(); 
% r.rotor.mesh.show_3D();

g=Graphs.Visu_Rotorsystem(r); % Instantiation of class Visu_Rotorsystem
g.show(); % Plot of a 3D-isometry of the rotor with sensors, loads,...

u_trans_rigid_body = r.compute_translational_rigid_body_modes; % Locates ..
                         % the translational DoF's of the rotor in a matrix
overall_mass = r.check_overall_translational_mass(u_trans_rigid_body) % ...
                         % Calculates the translational mass

%% Running system analyses
%% Running system analyses
%% Modal analysis

m=Experiments.Modalanalyse(r); % Instantiation of ... 
                        % class Modalanalyse

%m.calculate_rotor_only_without_damping(15);
m.calculate_rotor_only(15,100);

% m.calculate_rotorsystem_without_damping(7);
% rpmModalAnalysis=0;
% m.calculate_rotorsystem(16,rpmModalAnalysis);
% 
esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
Janitor.cleanFigures();
% 
% cmp = Experiments.Campbell(r);
% cmp.set_up(0:2e2:2e3,20); % input is 1/min, Number of Modes
% cmp.calculate();
% cmpDiagramm = Graphs.Campbell(cmp);
% cmpDiagramm.print_critical_speeds()
% cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
% esf.set_plots('half') % 'all', 'half' or desired mode number
% esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
Janitor.cleanFigures();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,500,[0:0.001:1]);
St_Lsg.compute_ode15s_ss
%St_Lsg.compute_euler_ss
%St_Lsg.compute_newmark
%St_Lsg.compute_sys_ss_variant

% 
%------------- Erzeuge Ausgabeformat der Loesung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'jm_whirling-chirp_500rpm');%'sweepx_0-300Hz_dm_AnregungLager2_4s-1kHz');
% 
% 
% %------------- Erzeuge Grafiken aus Loesung -------------------
% 
 t = Graphs.TimeSignal(r, St_Lsg);
 o = Graphs.Orbitdarstellung(r, St_Lsg);
 f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
 w = Graphs.Waterfalldiagramm(r, St_Lsg);
w2 = Graphs.WaterfalldiagrammTwoSided(r, St_Lsg);
% 
 for sensor = r.sensors
%          t.plot(sensor);
%          o.plot(sensor);
          f.plot(sensor);
%          %fo.plot(sensor,1);
%          %fo.plot(sensor,2);
%          w.plot(sensor);
%           w2.plot(sensor); % Wasserfall 2 Sided
         Janitor.cleanFigures();
 end
