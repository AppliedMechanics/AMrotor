%% Balken
% Teste JMs Idee: Anregung des Balkens wird nicht gemessen, sondern nur die
% "Lagerkraft"/"Federkraft" an anderer Stelle, die sich als Reaktionskraft
% ergibt

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
% clc
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

Config_Sim_Balken

r=Rotorsystem(cnfg,'Balken');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m

r.rotor.show_2D(); % compare discretisation and user input
r.rotor.geometry.show_2D(); 
r.rotor.geometry.show_3D(); % funktioniert nicht richtig

r.rotor.mesh.show_2D(); % show elements
r.rotor.mesh.show_2D_nodes(); % show geo_nodes
r.rotor.mesh.show_3D();

g=Graphs.Visu_Rotorsystem(r);
g.show();


r.rotor.assemble_fem;

% u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)


%% Running system analyses

% Frequenzgangfunktion
frf=Experiments.Frequenzgangfunktion(r,'rechtes Ende');
type = 'd'; %type:'d','v','a'
inPos = 500*1e-3;%[100:100:500]*1e-3;%
outPos = 500e-3;%[100,250]*1e-3;%
f = 1:1:1000;
rpm = 0;
[f,H]=frf.calculate(f,inPos,outPos,type,rpm,{'u_x'},{'u_x'});
[deltaIn,deltaOut]=frf.print_distance_delta;

visufrf = Graphs.Frequenzgangfunktion(frf);
visufrf.set_plots('bode','log','deg')
Janitor.cleanFigures();
% 
% m=Experiments.Modalanalyse(r);
% 
% m.calculate_rotorsystem(20,0);
% 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% % esf.set_plots('half') % 'all', 'half' or desired mode number
% %esf.set_plots('half','overlay')
% % esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
% Janitor.cleanFigures();
% 
% return
% 
% 
% % r.reduce_modal(10);
% 
% cmp = Experiments.Campbell(r);
% cmp.set_up(0:100e2:100e3,20); % input of set_up is (1/min, Number of Modes)
% cmp.calculate();
% % cmp.calculate_rotor_only();
% cmpDiagramm = Graphs.Campbell(cmp);
% cmpDiagramm.set_plots('all');
% cmpDiagramm.print_damping_zero_crossing();
% cmpDiagramm.print_critical_speeds()
% % cmpDiagramm.set_plots('backward');
% % cmpDiagramm.set_plots('forward');
% Janitor.cleanFigures();
% 
% return %stop execution -> Time integration is not yet functional

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg( r , 0 , (0.001:0.001:2) );%St_Lsg = Experiments.Stationaere_Lsg(r,[0:50:10e3],[0:0.001:2]); %obj = Stationaere_Lsg(a,drehzahlvektor,time)
St_Lsg.compute_ode15s_ss
%St_Lsg.compute_euler_ss
% St_Lsg.compute_newmark
%St_Lsg.compute_sys_ss_variant

% 
%------------- Erzeuge Ausgabeformat der Loesung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
% dataset_modalanalysis = d.compose_data();
dataset_modalanalysis = d.compose_data_sensor_wise();
datasetName = 'Balken_AnreungEnde_MessungEnde_Feder1e5';
d.save_data(dataset_modalanalysis,datasetName);
struct = d.convert_data_to_struct_sensor_wise(dataset_modalanalysis);
d.save_data(struct,datasetName);
d.write_data_to_unv(datasetName)
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

frf = Experiments.FrequenzgangfunktionTime(St_Lsg,'Ende Balken, Lager');
frf.calculate(r.sensors(5),r.sensors(3),0,'u_x','u_x',1,'boxcar');
visufrf = Graphs.Frequenzgangfunktion(frf);
visufrf.set_plots('bode','log','deg','coh')

frf = Experiments.FrequenzgangfunktionTime(St_Lsg,'Ende Balken, Anregung');
frf.calculate(r.sensors(2),r.sensors(3),0,'u_x','u_x',1,'boxcar');
visufrf = Graphs.Frequenzgangfunktion(frf);
visufrf.set_plots('bode','log','deg','coh')
% 
% return
 for sensor = r.sensors
         t.plot(sensor);
%          t.plot_Orbit(sensor);
%          o.plot(sensor);
         f.plot(sensor);
%          fo.plot(sensor,1); % Error Curve Fitting Toolbox muss installiert sein
%          fo.plot(sensor,2);
%          w.plot(sensor); % Wasserfall
%           Janitor.cleanFigures();
 end
