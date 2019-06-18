% Test 1/n octave computations using spectrum and time domain filters

% clear
% close all
% clc

% Generate a random time signal and assume a sampling frequency
fs=40000;
x=randn(1e6,1);

% Compute a PSD and a linear spectrum
N=32*1024;
win=ahann(N);
[P,fp]=apsdw(x,fs,N);
[L,fl]=alinspec(x,fs,win,50,50);

% Convert each of the spectra to 1/3 octaves
n=3;
[Poct,foct]=spec2noct(P,fp,n,'power');
[Llin,flin]=spec2noct(L,fl,n,'lin',ahann(N));

% figure
% loglog(foct,Poct,flin,Llin)