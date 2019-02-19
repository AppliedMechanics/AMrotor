function LastNumber = arecdata(T,fs,NoChan,prefix,startno,ChanSens,ChanUnit,Dof,Dir,ChanLabel);
% ARECDATA Records data from NI-card to abravibe file format
%
%       LastNumber = arecdata(T,fs,NoChan,prefix,startno,ChanSens,ChanUnit,Dof,Dir,ChanLabel)
%
%       LastNumber       Number of last file name <0 if error
%
%       T               Recording time
%       fs              sampling frequency
%       NoChan          Number of channels (always starting with ACH0)
%       prefix          start string for file number (Default 'abra')
%       startno         Number of first file name (Default 1)
%       ChanSens        Vector with sensitivity in mV/EU for each channel (Default 1000)
%       ChanUnit        String or struct with unit string for each channel. (Default 'V')
%       Dof             Vector with point number for each channel (Default 1)
%       Dir             struct with direction string for each channel ('+X','-X','+Y',...'+RX','-RX',...) (Default '+X')
%       ChanLabel       Struct with label(s) for each channel (Default '')
%
% For all structs (ChanUnit, Dir,...): if given as one string, the same string
% will be used for all channels. For ChanSens and Dof, if scalar, then same
% value is used for all channels.
%
% Look inside file for details of hardware selection.
% NOTE! This works only for 32-bit Windows currently. See help in MATLAB

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version:  1.0 2011-06-23   
%           1.1 2012-01-09  Added comment about 32-bit, and changed default
%                           HW
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin < 3
    error('Too few parameters!')
end
if nargin <4
    prefix='abra';
end
if nargin < 5
    startno=1;
end
if nargin < 6
    ChanSens=1000;
end
if nargin < 7
    ChanUnit='V';
end
if nargin < 8
    Dof = 1;
end
if nargin < 9
    Dir='+X';
end
if nargin < 10
    ChanLabel='';
end

if length(ChanSens) == 1
    ChanSens=ChanSens*ones(1,NoChan);
end
if ischar(ChanUnit)
    dum=ChanUnit;clear ChanUnit
    for n=1:NoChan
        ChanUnit{n}=dum;
    end
end
if ischar(ChanLabel)
    clear ChanLabel
    for n=1:NoChan
        s=['Channel ',int2str(n)];
        ChanLabel{n}=s;
    end
end

%==========================================================================

% Select your hardware by commenting what you do not use...
%HW='nidaq';
HW='winsound';          % Default changed 2012-01-09

% The following if statement may or may not work for you. The number at the
% end of the analoginput command may be different depending on
% configuration. This works on my computer...
if strcmp(upper(HW),'NIDAQ')
    AI = analoginput('nidaq',1)
    chan = addchannel(AI,0:NoChan-1)
else
    AI = analoginput('winsound',0)        
    chan = addchannel(AI,1:NoChan)   
end

% set up hardware for data acquisition
duration = T; %1 second acquisition
set(AI,'SampleRate',fs)
ActualRate = get(AI,'SampleRate');
set(AI,'SamplesPerTrigger',round(duration*ActualRate))
set(AI,'TriggerType','Manual')
blocksize = get(AI,'SamplesPerTrigger');
fs = ActualRate;

start(AI)
trigger(AI)
x = getdata(AI);

% Store data if everything went well
for n=1:NoChan
    FileName=strcat(prefix,int2str(startno+n-1));
    Header.FunctionType=1;                          % Time data
    Header.NumberSamples=length(x(:,1));
    Header.xStart=0;
    Header.xIncrement=1/fs;
    Header.Unit=ChanUnit{n};
    Header.Dof=1;
    Header.Dir='+X';           % 
    Header.Label=ChanLabel{n};
    Data=1000/ChanSens(n)*x(:,n);                   % Scale data to EU
    save(FileName,'Data','Header');
    fprintf('Saving data for channel #%i as %s...\n',n,FileName)
end
LastNumber=n;