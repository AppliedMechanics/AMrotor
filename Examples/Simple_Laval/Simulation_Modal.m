% Simple Laval - System analysis

%% Clean up

close all
clear all
% clc
%% Import
%% Import and formating of the figures

import AMrotorSIM.*; % path
Config_Sim_Modal; % corresponding cnfg-file

Janitor = AMrotorTools.PlotJanitor(); % Instantiation of class PlotJanitor
Janitor.setLayout(2,3); %Formatting of the figures

%% Compute Rotor
%% Assembly of the rotordynamic model

r=Rotorsystem(cnfg,'Laval-Rotor'); % Instantiation of class Rotorsystem
r.assemble; % assembly of the model parts, considering the ...
            % components (sensors,..) from the cnfg-file
r.rotor.assemble_fem; % assembly of the global (rotor) system ...
                      % matrices: M, D, G, K

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
%% Frequency response function

frf=Experiments.Frequenzgangfunktion(r,'FRF'); % Instantiation of ... 
                        % class Frequenzgangfunktion
type = 'd'; % FRF type: displ. 'd', veloc. 'v', accel. 'a'
inPos = [0,100,200]*1e-3; % Input positions on the rotor axis
outPos = 100e-3; % Output positions along the rotor axis
f = 1:2:100; % Frequency resolution of the FRF
rpm = 0; % Rotational speed
[f,H]=frf.calculate(f,inPos,outPos,type,rpm,{'u_x','u_y','psi_x'}, ... 
    {'u_x','psi_x'}); % Calculation of the FRF's from the three input ... 
                      % directions {'u_x','u_y','psi_x'} to the two ... 
                      % output directions {'u_x','psi_x'} at the ...
                      % corresponding positions
[deltaIn,deltaOut]=frf.print_distance_delta; % Plot of the gap between ...
                      % the desired positions along the rotor axis and ...
                      % the closest node position in the Command Window.

visufrf = Graphs.Frequenzgangfunktion(frf); % Instantiation of ... 
                        % class Frequenzgangfunktion for figures
visufrf.set_plots('amplitude','db') % Amplitude plot of all FRF's
visufrf.set_plots('phase','db') % Phase plot of all FRF's
visufrf.set_plots('bode','log','deg') % Bode plot of all FRF's
visufrf.set_plots('nyquist') % Nyquist plot of all FRF's
Janitor.cleanFigures(); % Formatting of the figures

%% Modal analysis

m=Experiments.Modalanalyse(r); % Instantiation of ... 
                        % class Modalanalyse
m.calculate_rotorsystem(10,3e3); % Calcualtion (#modes,rpm)

esf=Graphs.Eigenschwingformen(m); % Instantiation of ... 
                        % class Eigenschwingformen
esf.print_frequencies(); % Print of the eigenfrequencies ...
                         % with the corresponding modal damping ...
                         % in the Command Window
esf.plot_displacements(); % Figures of the eigenmodes ... 
                          % in specific directions
esf.set_plots('half','Overlay') % Plots of the odd-numbered eigenmodes ... 
                                % in overlay with the original rotor
Janitor.cleanFigures(); % Formatting of the figures


%% Campbell diagramm

cmp = Experiments.Campbell(r); % Instantiation of ... 
                        % class Campbell
cmp.set_up(1e2:1e2:10e3,8); % Set_up (omega range in 1/min, #modes)
cmp.calculate(); % Calculation

cmpDiagramm = Graphs.Campbell(cmp); % Instantiation of ... 
                        % class Campbell for figures
cmpDiagramm.print_damping_zero_crossing(); % Prints in the Command Window
cmpDiagramm.print_critical_speeds() % Prints in the Command Window
cmpDiagramm.set_plots('all'); % Figures
% cmpDiagramm.set_plots('backward');
% cmpDiagramm.set_plots('forward');
Janitor.cleanFigures(); % Formatting of the figures
