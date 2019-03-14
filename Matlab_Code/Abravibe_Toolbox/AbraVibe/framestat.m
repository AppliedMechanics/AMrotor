function F = framestat(y,N,func,NPlot)
% FRAMESTAT   Calculate frame statistics of signal
%
%       F = framestat(y,N,func,NPlot)
%
%       F           Column vector with result of func for each frame
%
%       y           Input time data
%       N           Frame size in samples
%       func        String with statistical function, eg. 'std'
%       NPlot       Logical, if true a frame statistics plot is created
%
% The variable func must contain a function returning a single value,
% based on N samples.
%
% This function can be used to obtain a rough test
% of the stationarity of the variable y.
%
% See also: STATCHK TESTSTAT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

%-----------------------------------------------------
%
if nargin < 3,
   error('Too few input arguments!');
elseif nargin == 3
   NPlot=0;
elseif nargin > 4
   error('Too many input arguments!');
end

for n=0:1:floor(length(y)/N)-1,
   F(n+1)=feval(func,y(n*N+1:(n+1)*N));
end

F=F';						% Output is a coumn vector

if NPlot
   x=1:1:length(F);
   plot(x,F);
   xlabel('Frame No.')
   S=cat(2,'Frame Statistics using function ''',func,'''');
   title(S)
end