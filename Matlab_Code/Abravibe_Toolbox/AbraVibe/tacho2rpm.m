function [rpm,t] = tacho2rpm(x,fs,TLevel,Slope,PPR,NewFs,FilterL)
% TACHO2RPM     Extract rpm/time profile from tacho time signal
%
%       [rpm,trpm] = tacho2rpm(x,fs,TLevel,Slope,PPRNewFs,FilterL)
%
%       rpm         Instantaneous rpm
%       t           Time axis for rpm
% 
%       x           Tacho time signal
%       fs          Sampling frequency (in Hz) for x
%       TLevel      Trigger level
%       Slope       +1, or -1 for positive and negative slope, respectively
%       PPR         Number of pulses per revolution for tacho signal
%       NewFs       (optional) sampling frequency for rpm. Default is fs
%       FilterL     Length of smoothing filter, Default is 5 pulses
%
% See also 
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-01-15 Modified to work in Octave
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin == 5
    NewFs = fs;
    FilterL=5;
elseif nargin == 6
    FilterL=5;
elseif nargin < 7
    error('Wrong number of input parameters')
end

% Define time axis for tacho signal
t=makexaxis(x,1/fs);

% Get trigger times
xDiff=diff(sign(x-TLevel));     % Produces +/- 2 where trigger event
tDiff=t(2:end);                 % Diff shifts one sample
if Slope > 0
    tTacho=tDiff(find(xDiff == 2));    % Tacho trigger positive slope instances
else
    tTacho=tDiff(find(xDiff == -2));   % Tacho trigger negative slope instances
end

% Calculate rpm from time between tacho pulses. Assign rpm to second tacho
% pulse of each pair
rpmt=60/PPR./diff(tTacho);              % Instantaneous rpm values
% Average each pair of rpm estimates and put on time of middle tacho pulse
rpmt=0.5*(rpmt(1:end-1)+rpmt(2:end));
tTacho=(tTacho(2:end-1));               % diff shifted one sample

% Smooth to obtain more stable values
if FilterL > 1
    a=1;
    b=1/FilterL*ones(1,FilterL);
    if strcmp(checksw,'MATLAB')
        rpmt=filtfilt(b,a,rpmt);
    else                            % Octave filtfilt does not work
        rpmt=filter(b,a,rpmt);
    end
end


% Interpolate to NewFs resolution
t=(0:1/NewFs:t(end))';
rpm=interp1(tTacho,rpmt,t,'linear','extrap');

