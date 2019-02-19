function plotscan(x,N,fs);
% PLOTSCAN      Scan a vector with time data and plot blockwise
% 
%               scan(x,N,fs)
%
%               x           Time data in column vector
%               N           Block size (number of samples per plot)
%               fs          Sampling frequency (for scaled x axis)
%
% This function plots N samples at a time of the function x, and pauses, until end of data is reached.
% N and dt are optional, to give dt, also N has to be given. N=1024 is used as default.
% If the parameter dt is given, the corresponding time axis is used for each plot , otherwise dt=1 is used.
%


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


% Set up depending on input
if nargin == 1
   N=1024;
   dt=1;
elseif nargin == 2
   dt=1;
elseif nargin == 3
    dt=1/fs;
else
   error('Wrong number of parameters!')
end

NoBlocks=fix(length(x)/N);
if (rem(length(x),N) ~= 0)
   NoBlocks=NoBlocks+1;
end
t=(0:dt:(N-1)*dt);
for n=1:NoBlocks
   plot(t,x(1+(n-1)*N:n*N));
   if nargin < 3
       xlabel('Sample Number')
   else
       xlabel('Time [seconds]')
   end
   disp('Press <ENTER> for next record...')
   pause
   t=(N*dt)+t;
end
disp('Last record. Function ended.')