%% Analytische Sollunwucht

%% Clean up
close all
clear all
clc

%% Restunwucht (theoretisch)
U_rest = 0

%% Soll-Unwucht 0°
m = 110e-3;  %[Kg]
r = 55e-3;   %[m]
phi = 0;

U_zusatz = m*r*exp(1i*phi*pi/180)

du= U_zusatz-U_rest

%% Darstellung

figure();
compass(du);

%% Soll-Unwucht 180°

phi = 180;

U_zusatz = m*r*exp(1i*phi*pi/180)

du= U_zusatz-U_rest

%% Darstellung

figure();
compass(du);