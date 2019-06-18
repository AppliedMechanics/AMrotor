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
x0 = [raW,raW]';

% lb=[0 0]; %lower bounds
% ub=[1 1]; %upper bounds

fun = @(x,xData)fun_lscurvefit_red(x,xData);
x = lsqcurvefit(fun,x0,[],ydata)%,lb,ub)