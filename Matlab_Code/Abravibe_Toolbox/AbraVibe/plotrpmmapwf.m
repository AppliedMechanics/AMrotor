function h = plotrpmmapwf(S,F,R)
% PLOTRPMMAPWF  Plot RPM map from fix fs in waterfall format
%
%       h = plotwf(S,F,R)
%
%       h       Handle to figure
%
%       F       Frequency axis
%       R       RPM axis
%       S       Spectrum matrix from rpmmap
%
% plotrpmmapwf(S,F,R) plots in current window
% NOT supported by Octave (due to lacking waterfall functionality)


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-01-15 Added check for Octave, as does not work
% This file is part of ABRAVIBE Toolbox for NVA

if strcmp(checksw,'OCTAVE')
    warning('This command is currently not working in Octave!')
    h=[];
else
    if nargout == 1
        h=figure;
    end
    
    [Nf,Nr]=size(S);
    
    waterfall(F,R,S')
    view(0,80)
    colormap([0,0,0])
    xlabel('Frequency [Hz]')
    ylabel('RPM')
end
