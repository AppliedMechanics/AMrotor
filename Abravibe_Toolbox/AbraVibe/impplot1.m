function h = impplot1(x,y,fs,N,TrigIdx,DIdx,TrigLevel)
% IMPPLOT1  Plot impact analysis plot with force/response. Internal
% function
%
%       h = impplot1(x,y,fs,N,TrigIdx,PreTrigger,DIdx)
%
%       h           Handle to figure
%
%       x           Input (force) signal
%       y           Response signal(s). If matrix, first column is used
%       fs          Sampling frequency
%       TrigIdx     Trigger indeces from imptrig
%       DIdx        Double impact index
%       TrigLevel   Optional. Plots constant level in plot if available
%                   TrigLevel is in percent (of max(abs(x)))

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Plot force and response signals in blue. Mark the "good" length N blocks
% with no double impacts in green, and double impact blocks in red
t=makexaxis(x,1/fs);
h=figure;
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
grid
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
grid
if exist('TrigLevel','var')
    subplot(2,1,1)
    hold on
    plot(t,TrigLevel*max(abs(x))/100*ones(size(t)),'m');
end
