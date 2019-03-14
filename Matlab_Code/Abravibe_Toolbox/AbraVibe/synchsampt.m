function  [xs,rpm,tc] = synchsampt(x,fs,tacho,TLevel,Slope,PPR,MaxOrd)
% SYNCHSAMPT   Resample data synchronously with RPM, based on tacho signal
%
%       [xs,rpm, tc] = synchsampt(x,fs,tacho,TLevel,Slope,PPR,MaxOrd)
%
%       xs          Synchronously sampled data
%       rpm         rpm x axis for xs
%       tc          x axis for xs in cycles
%       
%       x           Time data
%       fs          Sampling frequency for x
%       tacho       Tacho signal, sampled with frequency fs
%       TLevel      Trig level
%       Slope       Slope, +1 or -1 for positive and negative slope, respectively
%       PPR         Pulses per revolution of tacho signal
%       MaxOrd      Maximum order to be able to track (gives number of samples per
%                   revolution)


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2013-02-02 Updated syntax description
%          1.2 2018-05-08 Fixed bug to work for PPR>1
% This file is part of ABRAVIBE Toolbox for NVA

FilterL=7;
SampPerRev=2*MaxOrd;

% Find tacho instances
%=======================================
% Define time axis for tacho signal
t=makexaxis(tacho,1/fs);
% Get trigger times
xDiff=diff(sign(tacho-TLevel));     % Produces +/- 2 where trigger event
tDiff=t(2:end);                     % Diff shifts one sample
if Slope > 0
    tTacho=tDiff(find(xDiff == 2));    % Tacho positive slope instances
else
    tTacho=tDiff(find(xDiff == -2));   % Tacho negative slope instances
end

%=======================================
% Calculate rpm from time between tacho pulses. Assign rpm to second tacho
% pulse of each pair
rpmt=60/PPR./diff(tTacho);              % Instantaneous rpm values
tTacho=tTacho(2:end);                   % diff again shifts one sample
% Smooth to obtain more stable values
a=1;
b=1/FilterL*ones(1,FilterL);
rpm=filtfilt(b,a,rpmt);                 % This is rpm(t)

%=======================================
% Now to the synchronuous sampling part:
% Take only first tacho pulse for each revolution, so we have one tacho
% pulse per revolution
tTachoRed=tTacho(1:PPR:end);    % Bug fix 2018-05-08
% New sampling instances should now be at SampPerRev evenly spaced points
% between the two tacho pulses. The last sample, however, should be "one
% sample before" it reaches the next tacho pulse, to obtain a continuous
% signal
ts=[];
for n = 1:length(tTachoRed)-1
    tt=linspace(tTachoRed(n),tTachoRed(n+1),SampPerRev+1);
    ts=[ts tt(1:end-1)];
end

% Now resample x on these new time points
% First upsample x
x=resample(x,10,1);
fs=10*fs;
tr=makexaxis(x,1/fs);

% Resample original (upsampled) signal onto the angularly spread samples
xs=interp1(tr,x,ts,'linear','extrap');
% Find the instantaneous rpm values for each ts
rpm=interp1(tTacho,rpm,ts,'linear');
% Define tc in cycles
tc=makexaxis(xs,1/SampPerRev);
xs=xs(:);
tc=tc(:);
rpm=rpm(:);