clear,close all

%% Anregung laden
load('Sweep_Time_Anregung.mat')
[t,F] = get_vectors_LMS(Signal);
figure,plot(t,F),xlabel('t'),ylabel('F')

%% Ausgang laden
load('Sweep_Time_Ausgang.mat')
[t,Y0] = get_vectors_LMS(Signal_0);
figure,plot(t,Y0),xlabel('t'),ylabel('Y0')

[t,Y1] = get_vectors_LMS(Signal_1);
figure,plot(t,Y1),xlabel('t'),ylabel('Y1')

%% FFT
[f,Ffft] = perform_fft(t,F);
figure,plot(f,Ffft)
xlabel('f/Hz')
ylabel('Ffft')

figure,hold on
for k=1:size(Y0,2)
[f,Y0fft(:,k)] = perform_fft(t,Y0(:,k));
plot(f,Y0fft(:,k))
end
xlabel('f/Hz')
ylabel('Y0fft')
legend;

figure
[f,Y1fft] = perform_fft(t,Y1);
plot(f,Y1fft)
xlabel('f/Hz')
ylabel('Y1fft')

%% Auswertung
% Y1 ist wohl die Anregung mit einem Siunus-sweep von 0-500 Hz
% Y0 enthaelt die Messignale an 8 Stellen (piezo accelerometer sensors)

%% FRF-Berechnung
force = Y1;
displacement = Y0;
fmax = 250; % plot und fit bis 250 Hz
nWindows = 1;
SensorType = 'acc';
[frf,f,coh,fn,dr,modeshapes] = get_modalfrf(t,displacement,force,nWindows,fmax,SensorType);
fn,dr