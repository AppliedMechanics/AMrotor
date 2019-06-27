%% Set Path

InstDir = fileparts(which(mfilename));
addpath(InstDir)
pfad = strcat(fileparts(which(mfilename)),'/pathdef.m');
savepath pfad