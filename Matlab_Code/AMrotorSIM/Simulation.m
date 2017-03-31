% Johannes Maierhofer
% 28.03.2017,29.03.2017,30.03.2017

%% Clean up
close all
clear all
clc

%% Paths
addpath(strcat(fileparts(which(mfilename)),'\modules'));

  % Add Paths
       addpath(strcat(fileparts(which(mfilename)),'\modules\Rotor'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Lager'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Sensor'));
       addpath(strcat(fileparts(which(mfilename)),'\modules\Loads'));

  addpath(strcat(fileparts(which(mfilename)),'\modules\Simulation'));
  addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs'));
      addpath(strcat(fileparts(which(mfilename)),'\modules\Graphs\Campbell'));
           
%% Building rotorsystem

r = Rotorsystem("Cooles Rotorsystem");
r.show;

r.rotor.mesh()
%r.rotor.visu()

r.compute_matrices();
r.compute_loads();
%r.reduce_modal(10);

%r.sichern();

%% Running system analyses
Modalanalyse(r).show()

%% Running Time Simulation

%St_Lsg = Stationaere_Lsg(r,150);
%St_Lsg.show()
%St_Lsg.compute()

Hochlaufanalyse(r,[100:10:200]).show()

%% Postprocessing

c = Campbell(r);
c.show();

%% Infos
% %KoSy:
%        Z-Längsachse des Rotors
%        X-Z-Ebene
%        verschiebung in X1       X1
%        drehung um Y1            Beta_1
%        verschiebung in X2       X2
%        drehung um Y2            Beta_2
%                                  :
%                                 Xn
%        
%        Y-Z-Ebene
%        verschiebung in Y1       Y1
%        drehung um Z1            Alpha_1
%        verschiebung in Y2       Y3
%        drehung um Z2            Alpha_2
%                                   :
%                                 Yn
%                                 Alpha_n
