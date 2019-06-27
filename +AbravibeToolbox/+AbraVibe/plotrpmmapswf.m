function h = plotrpmmapwf(S,F,R)
% PLOTRPMMAPSWF  Plot RPM map from synchronuous sampling in waterfall format
%
%       h = plotrpmmapswf(S,F,R)
%
%       h       Handle to figure
%
%       F       Frequency axis
%       R       RPM axis
%       S       Spectrum matrix from rpmmap
%
% plotrpmmapswf(S,F,R) plots in current window
% Does not work in Octave (due to lacking waterfall functionality)

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-01-15 Modified to give warning if Octave
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
    xlabel('Order')
    ylabel('RPM')
end

