% Clean up

close all
clear all
clc

%
addpath(strcat(fileparts(which(mfilename)),'\modules'));

Config

%% Building rotor

r = Rotor("Cooler Rotor");
r.show_Rotor;

%% Adding Sensors to Rotor
for i=cnfg_sensor
r.add_Sensor(i);
end

for i=r.sensors
    i.print();
end

%% Adding Lager to Rotor
for i=cnfg_lager
r.add_Lager(i);
end

for i=r.lager
    i.print();
end

%% Running Simulation
testfunction();