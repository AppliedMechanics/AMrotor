% Achte darauf, die noetigen Zeilen in Simulation.m auszukommentieren
% z.B. alle plots auskommentieren,damit es schneller laeuft
% close all, clear auskommentieren


clear, close all
t_start_ges = tic
EF_soll = [52.5]; %in Hz

options = optimset('PlotFcns',{@optimplotx,@optimplotfval});

fun = @(gesucht) fun_delta_EF(gesucht, EF_soll)
startwert = 1.1504e+05;%N/m
[kML,fval,exitflag,output] = fzero(fun, startwert, options)%1e6)

toc(t_start_ges)

function [ delta ] = fun_delta_EF( gesucht , sollwert )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
kSchaetzung= gesucht(1)

Simulation

EF_ist = imag(m.eigenValues.lateral([4]))/2/pi;
disp([num2str(EF_ist(1)),'Hz'])
istwert = EF_ist;
delta = istwert-sollwert;
end