clear

load('Simulation-19-Feb-2019-noise250HzML1x_10s_1kHz-v1.mat')
write_dataset_for_EMA_of_Sim(dataset,'dataset_noise250HzML1x_10s_1kHz-v1')

filename = 'dataset_noise250HzML1x_10s_1kHz-v1_rpm0.mat';

script_MLPS_timeFRF_Noise % Auskommentieren von clear,close all und filename=... in script noetig