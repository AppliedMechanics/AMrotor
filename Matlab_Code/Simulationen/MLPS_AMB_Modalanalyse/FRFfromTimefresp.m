clear,close all
load('MDKr_symm.mat')

% wie in Experiment:
% inposition = [67.5, 587.5]*1e-3; %ANPASSEN
% outposition =[25,67.5,110,315,545,587.5,630]*1e-3; %ANPASSEN
% InputString = {'67.5mm','587.5mm'}; % Positionen des Inputs
% OutputString = {'25mm','67.5mm','110mm','315mm','545mm','587.5mm','630mm'}; % Positionen des Outputs

% wie in SYMM Simulation
inposition = [110,590]*1e-3; %ANPASSEN
outposition =[67.5,110,152.5,350,547.5,590,632.5]*1e-3; %ANPASSEN
InputString = {'110mm','590mm'}; % Positionen des Inputs
OutputString = {'67.5mm','110mm','152.5mm','350mm','547.5mm','590mm','632.5mm'}; % Positionen des Outputs


indof = zeros(size(inposition));
outdof = zeros(size(outposition));
for k = 1:length(inposition)
    position = inposition(k);
    node_nr = r.rotor.find_node_nr(position);
    indof(k) = (node_nr-1)*6+1;
end
for k = 1:length(outposition)
    position = outposition(k);
    node_nr = r.rotor.find_node_nr(position);
    outdof(k) = (node_nr-1)*6+1;
end

force1=importdata('Inputfiles/noise250Hz_1kHz.mat');
fs = 1/(force1.t(2)-force1.t(1));
force2=importdata('Inputfiles/noise250Hz_b.mat');
fs2 = 1/(force1.t(2)-force1.t(1));
if fs2~=fs
    error('input forces must be sampled with the same sampling rate')
end
x = [force1.x;force2.x]';
OutType = 'd';

%% Zeitantwort
tic
y = timefresp(x,fs,M,D,K,indof,outdof,OutType);
toc

%% FRF-Berechnung
N = 1024;
input = x;
output = y;
POverlap = 67;%50; % percentage overlap in welch's method % is this applicable
window = hsinew(N); % with windowing/averaging

[Gxx,Gyx,Gyy,f,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap);
[H,C,Cx]=xmtrx2frf(Gxx,Gyx,Gyy);

figure
plot(f(:),abs(Cx(:,1,2)))
xlabel('f/Hz')
ylabel('Coherence inputs')
title('Cx')
ylim([0 1])