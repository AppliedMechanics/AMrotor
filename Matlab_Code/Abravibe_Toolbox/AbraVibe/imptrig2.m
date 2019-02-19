function [TrigIdx, DIdx] = imptrig2(x,y,fs,N,TrigPerc,PreTrigger)
% IMPTRIG2       Impact testing triggering and double impact detection
%
%       [TrigIdx, DIdx] = imptrig2(x,y,fs,N,TrigPerc,PreTrigger)
%
%       TrigIdx         Indeces into x where trigger condition is fulfilled
%       DIdx            Indeces into x where a double impact is detected
%
%       x               Data (force) vector. If a matrix, first column is used
%       y               Response (acceleration) vector. If a matrix, first column is used
%       fs              Sampling frequency
%       N               Block size for double impact detection
%       TrigPerc        Trigger level, positive slope, in % of max(abs(x))
%       PreTrigger      Number of samples pretrigger (positive number!)
%       
% Double impacts are defined as follows:
% First all points where the force passes the trig level are found.
% Second, triggers that are found within 3 percent of blocksize after each trigger
% are interpreted as "normal", and due to filtering effects (when a short pulse 
% is sampled under its bandwidth, there is a ringing effect). These trigger
% positions are removed from the list.
% Third, trigger positions that remains, which are less than N
% samples larger than previous trigger idx are interpreted as double impacts.
% This means that you are better off setting a low TrigPerc (2-5 percent if 
% your force signal is not too noisy), so that you are likely to detect the 
% double impacts even if they are low.
%
% This is a special internal version that prompts user to select impacts,
% to be used with imp2frf2.
%
% NOTE! This function assumes positive peaks, and positive slope, so if you have 
% negative peaks, call the function with -x and take care of the direction change!
%
% See also IMP2FRF

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2014-07-06 Fixed bug which always made last impact untriggered
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 3
    PreTrigger=0;
end

a=x(end);                   % Bug fix 2014-07-06, to incorporate last impact
x(end)=max(x);              % Including x(end)=a below if statement, row 59

xM=max(abs(x));
TL=TrigPerc*xM/100;         % Trigger level in units of x
dx=diff(sign(x-TL));
TrigIdx=find(dx == 2);

% Remove triggers that are within 3 percent after another trigger.
if ~isempty(TrigIdx)
    Dt=diff(TrigIdx);
    xidx=find(Dt > round(0.03*N));
    TrigIdx=TrigIdx(xidx);
end
x(end)=a;

% Find double impacts: go through TrigIdx, if next value is < last value+N,
% mark last value as double impact
n=1;            % Trigger point to test
NewTrigIdx=[];
DIdx=[];
while n <= length(TrigIdx)
    D=TrigIdx(n+1:end)-TrigIdx(n);
    a=(D<N);
    if ~isempty(find(a==1))                     % If found double impact
        DIdx=[DIdx TrigIdx(n)];
        n=n+length(find(a==1))+1;               % Skip double impact triggers
    else
        NewTrigIdx=[NewTrigIdx TrigIdx(n)];
        n=n+1;
    end
end

% Make output and extract pretrigger from trigger level crossings
if ~isempty(NewTrigIdx)
    TrigIdx=NewTrigIdx-PreTrigger;
    % Check that last trigger index leaves N samples to end of record
    % If not, remove entirely as it cannot be used to indicate double impacts
    % either
    if TrigIdx(end)+N-1 > length(x)
        TrigIdx=TrigIdx(1:end-1);
        disp('Last trigger removed')
    end
else
    TrigIdx=0;                          % Means no trigger conditions found
end

if isempty(DIdx)
    DIdx=0;
else
    % Check that last double impact leaves N samples to end of record
    if DIdx(end)+N-1 > length(x)
        DIdx=DIdx(1:end-1);
    end
end

% Plot force and response signals in blue. Mark the "good" length N blocks
% with no double impacts in green, and double impact blocks in red
t=makexaxis(x,1/fs);
hTime=figure;
subplot(2,1,1)
plot(t,x)
title('Force signal (blue) and triggered blocks (green); double impact (red)')
hold on
for n=1:length(TrigIdx)
    idx=TrigIdx(n):TrigIdx(n)+N-1;
    plot(t(idx),x(idx),'g')
end
if DIdx ~= 0
    for n = 1:length(DIdx)
        idx=DIdx(n):DIdx(n)+N-1;
        plot(t(idx),x(idx),'r')
    end
end
hold off
subplot(2,1,2)
plot(t,y)
hold on
for n=1:length(TrigIdx)
    idx=TrigIdx(n):TrigIdx(n)+N-1;
    plot(t(idx),y(idx),'g')
end
if DIdx ~= 0
    for n = 1:length(DIdx)
        idx=DIdx(n):DIdx(n)+N-1;
        plot(t(idx),y(idx),'r')
    end
end
% Ask user to select impacts to use
fprintf('Select impacts by clicking on each (green) impact you want to include\n')
fprintf('Click return when done.\n')
[xx,d]=ginput;
% Find closest trigger events, if no events were selected, use them all!
if ~isempty(xx)
    xx=round(xx*fs);        % Scale in idx number
    for n=1:length(xx)
        [m,I]=min(abs(TrigIdx-xx(n)));
        T(n)=TrigIdx(I);    % Selected trigger index(es)
    end
else
    T=TrigIdx;
end
TrigIdx=T;

if isempty(TrigIdx)
    TrigIdx=0;
end