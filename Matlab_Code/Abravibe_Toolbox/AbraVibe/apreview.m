function apreview(N,fs,NoChan)
%APREVIEW View time data on one or more channels
%
%       apreview(N,fs,NoChan)
%
%       N               Number of samples
%       fs              Sampling frequency
%       NoChan          Number of channels
%
% Look inside file for details of hardware selection.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Select your hardware by commenting what you do not use...
HW='nidaq';
%HW='winsound';

% The following if statement may or may not work for you. The number at the
% end of the analoginput command may be different depending on
% configuration. This works on my computer...
if strcmp(upper(HW),'NIDAQ')
    AI = analoginput('nidaq',1)
    chan = addchannel(AI,0:NoChan-1)
else
    AI = analoginput('winsound',0)        % Change to winsound by commenting
    chan = addchannel(AI,1:NoChan)        % previous two lines and uncomment these
end

set(AI,'SampleRate',fs)
ActualRate = get(AI,'SampleRate');
set(AI,'SamplesPerTrigger',N)
set(AI,'TriggerType','Manual')
% set(AI,'InputRange',[-10 10])
blocksize = get(AI,'SamplesPerTrigger');
fs = ActualRate;

start(AI)
trigger(AI)
x = getdata(AI);
t=(0:1/fs:(blocksize-1)/fs)';

% set up plotting
h=figure;
if NoChan == 1
    plot(t,x)
    xlabel('Time [s]')
    ylabel('Channel 1')
elseif NoChan == 2
    subplot(2,1,1)
    plot(t,x(:,1))
    ylabel('Channel 1 [V]')
    subplot(2,1,2)
    plot(t,x(:,2))
    ylabel('Channel 2 [V]')
    xlabel('Time [s]')
elseif NoChan == 4
    subplot(2,2,1)
    plot(t,x(:,1))
    ylabel('Channel 1 [V]')
    subplot(2,2,2)
    plot(t,x(:,2))
    ylabel('Channel 2 [V]')
    subplot(2,2,3)
    plot(t,x(:,3))
    ylabel('Channel 3 [V]')
    subplot(2,2,4)
    plot(t,x(:,4))
    ylabel('Channel 4 [V]')
    xlabel('Time [s]')
else
    NoChans=length(ChanNumber);
    for n=1:NoChans
        subplot(NoChans,1,n)
        plot(t,x(:,n))
        ylabel(['Channel ' int2str(n) ' [V]'])
    end
    xlabel('Time [s]')
end
