function [O,freqs] = osdpick(PSpec,f,NoLines,DispFunc)
% ODSPICK   Extract ODS shapes from phase spectrum
%
%       [O,freqs] = osdpick(PSpec,f,NoLines,DispFunc)
%       or
%       [O,freqs] = osdpick(PSpec,f,NoLines,infreqs)
%
%        O          ODS shape(s) in column(s)
%        freqs      Frequency in Hz for corresponding column in O
%   
%        PSpec      Spectrum with amplitude and phase for each dof, for
%                   example from PSPEC or ACSDW
%        f          Frequency axis for PSpec (and DispFunc if used)
%        NoLines    A peak search is done on each function PSpec
%                   using NoLines (odd number) around each peak
%                   if NoLines=0 the frequencies are picked without a peak
%                   search
%        DispFunc   If used, this function (or matrix) will be plotted 
%                   instead of PSpec in the interactive peak pick display
%        infreqs    Vector with frequencies to pick for 'automatic' pick.
%                   must be shorter than f
%
% With the first syntax, this function displays a spectrum and allows for
% the user to pick the frequencies for which ODS shapes are to be
% estimated.
% With the second syntax, the ODS shapes are picked using the frequencies 
% in the vector infreqs, without interaction.
%
% See also  alinspecp acsdw pcaxy

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2014-03-17 Implemented second syntax with infreqs
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 3
    figure
    semilogy(f,abs(PSpec));
    DispFunc=abs(PSpec);
elseif nargin == 4
    if length(DispFunc) == length(f)
        figure
        semilogy(f,abs(DispFunc))
        DispFunc=abs(DispFunc);
    else
        infreqs=DispFunc;
    end
end

if ~exist('infreqs','var')
    title('Pick frequencies, then <RETURN>')
    [xx,yy]=ginput;
    idxs=round(xx/(f(2)-f(1)));
    freqs=f(idxs);
else
    freqs=infreqs;
    idxs=round(infreqs/(f(2)-f(1)));
end

% Pick shapes
[N,D]=size(PSpec);
for freq = 1:length(freqs)
    for d = 1:D
        idx=idxs(freq);
        if NoLines == 0
            O(d,freq)=PSpec(idx,d);
        else
            [dum,midx]=max(PSpec(idx-(NoLines-1)/2:idx+(NoLines-1)/2,d));
            O(d,freq)=PSpec(midx+idx-(NoLines-1)/2-1,d);
        end
    end
end
