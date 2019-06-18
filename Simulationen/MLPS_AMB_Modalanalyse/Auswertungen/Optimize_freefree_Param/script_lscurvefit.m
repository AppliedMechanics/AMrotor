% script_lscurvefit

%% MLPS - AMB - Modalanalyse
% Zur Optimierung der Parameterwerte fuer free-free-System

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
% clc
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);

%% Experimentdaten
load('M4+X_A2-X.mat')
% disp(FRF.Header.Title)
% disp(Coh.Header.Title)
% disp(' ')
fExp=FRF.Header.xStart:FRF.Header.xIncrement:(FRF.Header.NoValues-1)*FRF.Header.xIncrement;
HExp = FRF.Data*9.80665; % Umrechnung in m/s^2/N
CohExp = Coh.Data;

ydata = abs(HExp(41:1000)); % von 10 bis 250Hz

%% lscurvefit
raW=4e-3;
x0 = [raW,raW,1.276499,1.487212e-3,2.832751e-3,0.85074,4.840066e-4,4.036839e-4];


fun = @(x,xData)fun_lscurvefit(x,xData);
x = lsqcurvefit(fun,x0,[],ydata)