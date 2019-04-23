%% MLPS - AMB - Modalanalyse
% Zur Berechnung der Rohdaten für die Modalanalyse
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

% Config_Sim_Minimal
% Config_Sim_freefree
Config_Sim_eingebaut
% Config_Sim
% Config_Sim_symm
% Config_Sim_CAD
% Config_Sim_Scheiben
% Config_Sim_Scheiben_symm
% Config_Sim_Laval
% Config_Sim_MLZapfen_Spannhuelsen
% Config_Sim_onlyMLZapfen
% Config_Sim_Scheibe_Spannhuelsen
% Config_Sim_Scheibe_only

r=Rotorsystem(cnfg,'MLPS-System');
r.assemble;
r.show;

r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); 
% r.rotor.geometry.show_3D(); % funktioniert nicht richtig

% r.rotor.mesh.show_2D(); % show elements
% r.rotor.mesh.show_2D_nodes(); % show geo_nodes
% r.rotor.mesh.show_3D();

% g=Graphs.Visu_Rotorsystem(r);
% g.show();

 r.rotor.assemble_fem;
 r.rotor.matrices.D = importdata('D_damping_modal_expansion.mat');% Daempfung aus estimate_damping_modal_expansion.m, setze dann d_bearing=0;
%  for bearing=r.bearings
%      bearing.cnfg.damping=0;
%  end
  
u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body);disp(['m=',num2str(overall_mass.m_x,3),'kg']);
nEle = length(r.rotor.mesh.elements);

%% Running system analyses

m=Experiments.Modalanalyse(r);

%m.calculate_rotor_only_without_damping(15);
%m.calculate_rotor_only(15,100);

% m.calculate_rotorsystem_without_damping(7);
rpmModalAnalysis=0;
m.calculate_rotorsystem(16,rpmModalAnalysis);
% return

esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
Janitor.cleanFigures();

% % check scaling of eigenvectors: modal mass or modal A or different?
% [M,D,G,K] = r.assemble_system_matrices(rpmModalAnalysis);
% V=m.eigenVectors.complex;
% % for k=1:size(V,2) %check modal mass
% %     modalMass(k) = V(:,k)'*M*V(:,k);
% % end
% modalMass=V'*M*V;
% % modalMass
% clear M D G K V

% % create MAC matrix (using abravibe toolbox)
% modesToCompare = [6,11,12,14,17,21,23];%free-free;%[3,5,7,10,12,14,17];%[3,5,7,10,12];%
% p = m.eigenValues.lateral(modesToCompare);
% V = m.eigenVectors.Sensor.lat_x(:,modesToCompare);
% % MAC=amac(V); % auto-MAC
% figure
% plotmac(MAC,p);

% return
% fuer ./Auswertungen/free_free_Vergleich_Sim_Exp/
Sensor = get_sensor_eigenmodes(esf)
save ./Auswertungen/supported_Vergleich_Sim_Exp/Simulation_Modes_supported_Sensors_P3000 Sensor
Sim = get_simulation_eigenmodes(esf)
save ./Auswertungen/supported_Vergleich_Sim_Exp/Simulation_Modes_supported_P3000 Sim
[M,D,~,K] = r.assemble_system_matrices(0);
save ./Auswertungen/supported_Vergleich_Sim_Exp/Simulation_Matrices_P3000 M D K r
clear M D K Sensor
return

cmp = Experiments.Campbell(r);
cmp.set_up(0:2e2:2e3,10); % input is 1/min, Number of Modes
cmp.calculate();
cmpDiagramm = Graphs.Campbell(cmp);
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
% esf.set_plots('half') % 'all', 'half' or desired mode number
% esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
Janitor.cleanFigures();
return

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,00,[0:0.001:1]);
%St_Lsg.compute_ode15s_ss           %läuft leider immer noch nicht!
St_Lsg.compute_ode15s_ss_variant
%St_Lsg.compute_euler_ss
%St_Lsg.compute_newmark
%St_Lsg.compute_sys_ss_variant

% 
%------------- Erzeuge Ausgabeformat der Lösung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_modalanalysis = d.compose_data();
d.save_data(dataset_modalanalysis,'10e_noise1kHz250Hz_MIMOx_lowDamp_10s_1kHz');%'sweepx_0-300Hz_dm_AnregungLager2_4s-1kHz');
% 
% 
% %------------- Erzeuge Grafiken aus Lösung -------------------
% 
 t = Graphs.TimeSignal(r, St_Lsg);
%  o = Graphs.Orbitdarstellung(r, St_Lsg);
%  f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
% w = Graphs.Waterfalldiagramm(r, St_Lsg);
w2 = Graphs.WaterfalldiagrammTwoSided(r, St_Lsg);
% 
 for sensor = r.sensors
          t.plot(sensor);
          o.plot(sensor);
%           f.plot(sensor);
%          %fo.plot(sensor,1);
%          %fo.plot(sensor,2);
%          %w.plot(sensor);
           w2.plot(sensor); % Wasserfall 2 Sided
         Janitor.cleanFigures();
 end
