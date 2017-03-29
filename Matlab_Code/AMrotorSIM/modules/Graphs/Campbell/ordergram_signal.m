function [Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal()
% [Fs,t,Ticks,rpstheo,encodersig,signal]=ordergram_signal()
% 
% Creates a artificial signal which could be measured at a 
% enginge runup/rundown
%
% Fs          sample frequency
% t           time axis
% Ticks       Impulses per revolution of the speed sensor
% rpstheo     theoretical rotational speed in rps
% encodersig  the signal from the encoder itself
% signal      the signal from an accelerometer or similar thing
% (c) B. Käferstein, Aug., 2002

disp(' ');
disp('Time axis t is always assumed to start at 0!');
disp('Fixed frequencies at 13, 31 and 59 Hz.');
disp('Orders at 1,3,5,7 11.2 x speed in RPS.');
disp('Additional modulations and noise signals.');

Fs          = 8000;
t           = [0:1/Fs:20];
Ticks       = 10;                               % Number of Impulses per revolution of light barrier
rpstheo     = (t.^6.*exp(-t/1))+10;             % Theoretical rotational speed in rev. per sec.
angle4ticks = cumsum(2*pi*rpstheo)/Fs;          % Total angle = Integrate(ang. veloc.)|0...t
encodersig  = (1+sin(angle4ticks*Ticks))>=1;    % Calculation of encoder signal

% Create a measurement signal with some fix, variing and noisy parts:
backnoise   = 0.02*conv(randn(1,length(encodersig)-11),[-1 0 2 -3 5 4 0 0 0 -2 0 0]);
backsignal  = 0.1*sin(t).*sin(2*pi*2*pi*13*t)+...
              0.2*cos(t.^1.5).*cos(2*pi*2*pi*31*t)+...
              +0.15*sin(2*pi*2*pi*59*t);
ordersignal = 1*sin(t*2.9).*sin(angle4ticks*1)+...
              0.5*sin(t*2.9).*sin(angle4ticks*3)+...
              0.3*sin(t*2.9).*sin(angle4ticks*5)+...
              0.1*sin(t*2.9).*sin(angle4ticks*7)+...
              0.4*abs(cos(angle4ticks/5)).*sin(angle4ticks*11.2);
          
signal      = backnoise+backsignal+ordersignal;

signal = detrend(signal);

