function [x,t] = agetdata(T,fs,NoChan);
% AGETDATA Acquires time data from NI-card analog inputs into MATLAB
%
%       [x,t] = agetdata(T,fs,NoChan)
%
%       x       Matrix with time data in columns
%       t       Time axis
%
%       T       Recording time
%       fs      sampling frequency
%       NoChan  Number of channels (always starting with ACH0)
%
% Look inside file for details of hardware selection.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Select your hardware by commenting what you do not use...
HW='nidaq';
% HW='winsound';

% The following if statement may or may not work for you. The number at the
% end of the analoginput command may be different depending on
% configuration. This works on my computer...
if strcmp(upper(HW),'NIDAQ')
    AI = analoginput('nidaq','Dev1')
    chan = addchannel(AI,0:NoChan-1)
else
    AI = analoginput('winsound',0)        
    chan = addchannel(AI,1:NoChan)   
end

duration = T; %1 second acquisition
set(AI,'SampleRate',fs)
ActualRate = get(AI,'SampleRate');
set(AI,'SamplesPerTrigger',duration*ActualRate)
set(AI,'TriggerType','Manual')
% set(AI,'InputRange',[-10 10])
blocksize = get(AI,'SamplesPerTrigger');
Fs = ActualRate;

start(AI)
trigger(AI)
x = getdata(AI);
if nargout==2
    t=(0:1/Fs:(blocksize-1)/Fs)';
end
