%% MLPS - AMB - Modalanalyse
% Zur Berechnung der Rohdaten für die Modalanalyse
% SIRM2019 Beitrag
% 20.08.2018

%% Import

import AMrotorSIM.*


%% Compute Rotor

Config_Sim_eingebaut

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
m.calculate_rotorsystem(30,rpmModalAnalysis);
% return

esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% Janitor.cleanFigures();

