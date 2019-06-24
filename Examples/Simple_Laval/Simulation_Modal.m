%% Simple Laval - Modalanalyse


%% Clean up
close all
clear all
% clc
%% Import

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

Config_Sim_Modal

r=Rotorsystem(cnfg,'Laval-System');
r.assemble; %fuehrt Funktion assemble.m mit Eingabe Objekt r aus Klasse Rotorsystem aus
r.show; % Funktion AMrotor\Matlab_Code\+AMrotorSIM\+Rotor\+FEMRotor\@FeModel\print.m


r.rotor.show_2D(); % compare discretisation and user input
% r.rotor.geometry.show_2D(); % show user input
% r.rotor.geometry.show_3D(); % show user input 3D, does not show last section

% r.rotor.mesh.show_2D(); % show generated elements
% r.rotor.mesh.show_2D_nodes(); % show nodes and corresponding inner/outer radius
% r.rotor.mesh.show_3D(); % show 3D rotor with mesh


g=Graphs.Visu_Rotorsystem(r);
g.show(); % 3D rotor system with components


r.rotor.assemble_fem; % assemble structure matrices

u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body)


%% Running system analyses

% Frequenzgangfunktion
frf=Experiments.Frequenzgangfunktion(r,'Test-FRF');
type = 'd'; %type:'d','v','a'
inPos = 100e-3;%[100:100:500]*1e-3;%
outPos = 100e-3;%[100,250]*1e-3;%
f = 1:1:1000;
rpm = 0;
[f,H]=frf.calculate(f,inPos,outPos,type,rpm);
[deltaIn,deltaOut]=frf.print_distance_delta;

visufrf = Graphs.Frequenzgangfunktion(frf);
visufrf.set_plots('amplitude',1,1,'db')
visufrf.set_plots('phase',{'u_x','u_y'},'u_x','db')
visufrf.set_plots('bode',[1,4],[1,2,3],'log','deg')
visufrf.set_plots('nyquist','u_y','u_y')
Janitor.cleanFigures();

% Modalanalyse
m=Experiments.Modalanalyse(r);

m.calculate_rotorsystem(10,3e3); %(#modes,rpm)

esf= Graphs.Eigenschwingformen(m);
esf.print_frequencies();
esf.plot_displacements();
esf.set_plots('half') % 'all', 'half' or desired mode number
%esf.set_plots('half','overlay')
% esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
Janitor.cleanFigures();


% Campbell-Diagramm
cmp = Experiments.Campbell(r);
cmp.set_up(1e2:1e2:10e3,8); 
cmp.calculate();% input of set_up is (1/min, Number of Modes)
cmpDiagramm = Graphs.Campbell(cmp);
cmpDiagramm.print_damping_zero_crossing();
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
Janitor.cleanFigures();


%% Berechne die Frequenzgangfunktion
rpm=1000;
f=0:2:1000;
omega=rpm/60*2*pi;
[M,C,G,K] = r.assemble_system_matrices(rpm);
D = C+omega*G;
%Funktion findet die nächstgelegenen Knoten zu den angegebenen inputs und
%outputs und setzt die Freiheitsgradnumer der dazugehörigen x-Richtung in
%die Funtion mck2frf von Abravibe ein, 
% siehe dazu auch die Hilfe von mck2frf
tic,input=280e-3;output=333e-3;H = get_FRF_from_MDK(r,f,M,D,K,input,output,'d');toc %'d' fuer displacement; 
figure,subplot(2,1,1),semilogy(f,abs(H),'DisplayName','FEM');ylabel('FRF magnitude'),subplot(2,1,2),plot(f,angle(H)*180/pi,'DisplayName','FEM');xlabel('f//Hz'),ylabel('angle')
clear M D K C G