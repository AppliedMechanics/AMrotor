%% Set Path

InstDir = fileparts(which(mfilename));
addpath(InstDir)
% add abravibe toolbox
addpath(strcat(InstDir,filesep,'Abravibe_Toolbox'));
addpath(strcat(InstDir,filesep,'Abravibe_Toolbox',filesep,'abravibe'));
addpath(strcat(InstDir,filesep,'Abravibe_Toolbox',filesep,'animate'));
pfad = strcat(fileparts(which(mfilename)),'/pathdef.m');
savepath pfad