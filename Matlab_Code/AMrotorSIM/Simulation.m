% Johannes Maierhofer
% 28.03.2017

%% Clean up

close all
clear all
clc

%% Paths
addpath(strcat(fileparts(which(mfilename)),'\modules'));
   %% Add Paths
   addpath(strcat(fileparts(which(mfilename)),'\modules\Rotor'));
   addpath(strcat(fileparts(which(mfilename)),'\modules\Lager'));
   addpath(strcat(fileparts(which(mfilename)),'\modules\Sensor'));
   
  addpath(strcat(fileparts(which(mfilename)),'\modules\Simulation'));
  addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs'));
      addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs\Campbell'));
           
%% Building rotorsystem

r = Rotorsystem("Cooles Rotorsystem");
r.show;

r.rotor.mesh()
r.rotor.print()
%r.rotor.visu()

r.compute_matrices();
r.reduce_modal();


for i=r.lager
    i.print();
end

for i=r.sensors
    i.print();
end



%% Running Simulation

Modalanalyse(r).show()
Hochlaufanalyse(r,[100:10:200]).show()

%% Postprocessing

c = Campbell(r.rotor);
c.show();
