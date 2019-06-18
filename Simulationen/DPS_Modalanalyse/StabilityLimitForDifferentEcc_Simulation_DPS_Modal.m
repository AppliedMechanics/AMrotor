%% DPS - Modalanalyse


%% Clean up
close all
clear all
% clc
ticGes=tic;

% EccStr={    '0',    '01',   '03',   '05',   '08',   '09',   '095'};
% Ecc = [     0,      0.1,    0.3,    0.5,    0.8,    0.9,    0.95];
Ecc = 0:0.01:0.95;
Ecc=0.64
for k=1:length(Ecc)
    EccStr{k}=num2str(Ecc(k)*100);
end
%% Import
for kSealEcc = 1:length(EccStr)
    tic
    EccStr{kSealEcc}
%name der Dichtungskoeff fuer unterschiedliche Exzentrizitaet 
Seal1Filename = ['Inputfiles/SealTestRigEcc/TestRigLam1Ecc',EccStr{kSealEcc},'.mat'];
Seal2Filename = ['Inputfiles/SealTestRigEcc/TestRigLam2Ecc',EccStr{kSealEcc},'.mat'];

import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Compute Rotor

StabilityLimitForDifferentEcc_Config_Sim_DPS_Modal
% Config_Sim_DPS_Modal_ohne_Dichtung

r=Rotorsystem(cnfg,'DPS-System');
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

% f=[0:0.1:19.5,20:0.5:1000]';
% rpm=1000;omega=rpm/60*2*pi;
% [M,D,G,K] = r.assemble_system_matrices(rpm);
% % tic,H = get_FRF_from_MDK(r,f,M,(D+omega*G),K,422e-3,(333)*1e-3,'d');toc %fuer mit Dichtung
% tic,input=280e-3;output=333e-3;H = get_FRF_from_MDK(r,f,M,(D+omega*G),K,input,output,'d');toc %fuer mit Dichtung x/F
% save('C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\diskreteDrehzahl\FRFKraftSim1krpmSealEcc099.mat','f','H','input','output')
% % tic,input=280e-3;output=(333-6)*1e-3;H = get_FRF_from_MDK(r,f,M,(D+omega*G),K,input,output,'d');toc %H=x/F % fuer ohne Dichtung
% % save('C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\diskreteDrehzahl\FRFKraftSim1krpmNoSeal.mat','f','H','input','output')
% % save('C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\diskreteDrehzahl\FRFKraftSim1krpmSealNurDxxkxy.mat','f','H','input','output')
% % save('C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\diskreteDrehzahl\ML2zuEddy2\FRFKraftSim1krpmSealLamML2zuEddy2.mat','f','H','input','output')
% % uiopen('C:\Users\Michael\Documents\Uni\Masterarbeit\DPS-Messungen-lokal\20190425 - stehender Rotor ohne Dichtung\Vgl_BurstRand_steppedSine.fig',1)
% % subplot(2,1,1),yyaxis left,hold on,plot(f,abs(H),'DisplayName','FEM H=x/F');subplot(2,1,2),yyaxis left,hold on,plot(f,-angle(H)/pi*180,'DisplayName','FEM H=x/F');
% % disp('evtl Umrechnung von F in I zum Vgl. der FRF')
% figure,subplot(2,1,1),semilogy(f,abs(H),'DisplayName','FEM');ylabel('FRF magnitude'),subplot(2,1,2),plot(f,angle(H)*180/pi,'DisplayName','FEM');xlabel('f//Hz'),ylabel('angle')
% clear M D K

% % fuer estimate_damping_modal_expansion.m
% [M,D,~,K] = r.assemble_system_matrices(0);
% save('rotor_free_free.mat','r','M','K')
% clear M D K

% return
%% Running system analyses
% 
% % Modalanalyse
% m=Experiments.Modalanalyse(r);
% 
% m.calculate_rotorsystem(20,1e3)%10e3);
% 
% esf= Graphs.Eigenschwingformen(m);
% esf.print_frequencies();
% esf.plot_displacements();
% % esf.set_plots('half') % 'all', 'half' or desired mode number
% % esf.set_plots('all','overlay','Skip',4)
% % esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) %specify additional options, first input is index of mode
% Janitor.cleanFigures();
% % 
% % Sim = get_simulation_eigenmodes(esf);
% % save('C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\diskreteDrehzahl\ModesSim1krpm','Sim','esf')
% % 
% % return

% Campbell-Diagramm
cmp = Experiments.Campbell(r);
cmp.set_up(5e2:1e2:70e3,4); 
cmp.calculate();% input of set_up is (1/min, Number of Modes)
cmpDiagramm = Graphs.Campbell(cmp);
[ZeroCrossingForward{kSealEcc}, ZeroCrossingBackward{kSealEcc}]=cmpDiagramm.print_damping_zero_crossing();
cmpDiagramm.print_critical_speeds()
cmpDiagramm.set_plots('all');
% cmpDiagramm.set_plots('backward');
cmpDiagramm.set_plots('forward');
Janitor.cleanFigures();

% % to plot the Campbell-Diagram from the simulation into the waterfalldiagram from the experiment
% plot_Campbell_stem3(cmpDiagramm,1e-3)
% plot_Campbell_plot(cmpDiagramm)
close all
tic
end
toc(ticGes)
% save C:\Users\Michael\Documents\GitLabProjekte\Masterarbeit\MA_Kreutz_2019\figures\DPS\Hochlauf\StabGrenzeSim\StabGrenzeUeberEccNeu rpmZeroCrossingForward rpmZeroCrossingBackward Ecc
