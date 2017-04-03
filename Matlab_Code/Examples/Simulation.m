% Johannes Maierhofer
% 28.03.2017,29.03.2017,30.03.2017,31.03.2017,03.04.2017

%% Clean up
close all
clear all
clc

%% Paths
addpath(strcat(fileparts(which(mfilename)),'\modules'));

            % Add Paths
%       addpath(strcat(fileparts(which(mfilename)),'\modules\Rotor'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Lager'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Sensor'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Loads'));

  addpath(strcat(fileparts(which(mfilename)),'\modules\Simulation'));
  addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs'));
    addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs\Campbell'));
    addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs\Orbits'));
             addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs\Geometrie'));
           
%% Building rotorsystem

r = Rotorsystem("Cooles Rotorsystem");
r.show;

r.rotor.mesh()
r.rotor.visu()

r.compute_matrices();
r.compute_loads();
%r.reduce_modal(10);

%r.sichern();

%% Running system analyses
%Modalanalyse(r).show()

%% Running Time Simulation

St_Lsg = Stationaere_Lsg(r,50,[0:1e-3:5]);
St_Lsg.show()
St_Lsg.compute()

w = Wegorbit(r);
w.plot(r.sensors(1:2));

%data = r.generate_sensor_output();


%Hochlaufanalyse(r,[100:10:200]).show()

%% Postprocessing

%c = Campbell(r);
%c.show();