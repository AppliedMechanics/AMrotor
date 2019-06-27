function h = plotrpmmapsc(S,F,R,MinY,MaxY,Mode)
% PLOTRPMMAPSC  Plot a color map of RPM map data from synchronuous sampling
%
%       h = plotrpmmapc(M,F,R,MinY,MaxY,Mode)
%
%       h           Handle to figure (optional)
%
%       S           Spectrum map
%       F           Order axis for columns in S
%       R           RPM axis for rows in S
%       MinY        "Bottom" of scale for color map, default is 3
%       MaxY        "Top" of scale for color map, default is 0
%       Mode        'lin', or 'log', default is 'log'
%
% For Mode='lin', MinY and MaxY are linear values. For Mode='log', they are
% orders of magnitude related to the max value in S, so that for example
% plotrpmmapc(S,F,R,3,2,'log') means that MinY will be
% max(max(abs(S)))/10^3 and MaxY will be max(max(abs)))*10^2


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 6
    if strcmp(upper(Mode),'LOG')
        MinY=max(max(abs(S)))/10^MinY;
        MaxY=max(max(abs(S)))*10^MaxY;
    end
elseif nargin == 5
    Mode = 'log';
elseif nargin == 4
    MaxY = max(max(abs(S)));
    Mode = 'log';
elseif nargin == 3 
    MinY=max(max(abs(S)))/1e3;
    MaxY = max(max(abs(S)));
    Mode = 'log';
else
    error('Wrong number of input parameters')
end

if nargout == 1
    h=figure;
else
end

if strcmp(upper(Mode),'LOG')
    imagesc(R,F,log10(abs(S)),[log10(MinY) log10(MaxY)])
else
    imagesc(R,F,abs(S),[MinY MaxY])
end
set(gca,'YDir','normal')
ylabel('Order')
xlabel('RPM')
