function [p,L,fLimits] = frf2ptime(H,f,Nlines,MaxModes,MifType,EstType,freqRng)
%FRF2PTIME Time domain MDOF methods for parameter extraction
%
%       [p,L,fLimits] = frf2ptime(H,f,Nlines,MaxModes,MifType,EstType)
%
%       p           Vector with complex poles with positive imaginary part
%       L           This is a variable which varies with the EstType
%                   for EstType='prony' or 'lsce', L = 1.
%                   for EstType='ptd', L contains the modal participation
%                   factors
%       fLimits     2-by-1 vector with flo, fhi of selected frequency range
%
%       H           FRF matrix with accelerances, N-by-D-by-R
%       f           Frequency axis for H
%       Nlines      Number of values in h(t) used for estimation, normally
%                   200-500
%       MaxModes    Maximum number of modes, limit for stabilization
%                   diagram
%       MifType     Mode indicator function type for plot in stabilization
%                   diagram. Can be a column vector with size(f), or a
%                   string corresponding to the input of the AMIF command.
%                   Empty vector or 'default' uses the default mif type in
%                   AMIF.
%       EstType     Estimation method string
%                   'prony' is a local method useful mostly for a single
%                   FRF, but works also for several responses, although in
%                   a tedious way, as one stabilization diagram is produced
%                   for every response. Prony is also known as complex
%                   exponential method.
%                   'lsce' uses complex exponential single reference
%                   method using all data in H (even if R>1) (Default)
%                   'ptd' uses the polyreference time domain method to
%                   produce poles and modal participation matrix
%                   'mmitd' uses a modified multiple-reference Ibrahim time 
%                   domain method to produce poles and modal participation 
%                   matrix
%      freqRng      To avoid the graphical interface to pick the minimum
%                   and maximum frequency e.g. [1,200] % added by M. Kreutz
% 
% This function plots the FRFs for the first reference (if several), and
% allows a selection of frequency range to be used. Thereafter a
% stabilization diagram is presented where you select the modes interactively.
%
% See inside file for some parameters you can hardcode to control behavior.
% Each curve fitting method is also documented inside the file.
%
% See also FRFP2MODES FRF2MSDOF

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-04-15 Added PTD method
%          1.2 2013-03-09 Changed parameters to include FRF enhancement
%                         with the new function enhancefrf.
%          1.3 2013-06-09 Fixed bug in option 'prony' due to previous
%                         changes.
%          1.4 2014-01-27 Extracted the actual parameter estimation to
%                         function ir2ptime for flexibility.
%          1.5 2017-11-29 Bugfix to cope with empty MifType
%          1.6 2018-05-10 Added MMITD, Modified multireference Ibrahim time domain
%
% This file is part of ABRAVIBE Toolbox for NVA

%=========================================================================
% Initialize hardcode parameters
%=========================================================================
CondHmtrx=1;                % Set to 1 to include a condensation of the H
%                             matrix using an SVD enhancement approach
%                             Set to 0 to avoid FRF condensation.
SelNoSingVal=0;             % If CondHmtrx=1 this parameter controls whether
%                             a manual selection is done by a singular
%                             value plot, or not. If this parameter is 0
%                             then an automatic selection of a suitable
%                             smallest eigenvalue is used.
%=========================================================================
% Check input parameters
%=========================================================================
if nargin < 4
    error('Too few input parameters, must be >= 4')
elseif nargin == 4
    MifType='MIF1';
    EstType='LSCE';
elseif nargin == 5
    MifType=upper(MifType);
    EstType='LSCE';
elseif nargin == 6
    EstType=upper(EstType);
end

%=========================================================================
% Make initial calculations and frequency selection
%=========================================================================
% Plot FRFs and allow selection of frequency range
h=figure;
semilogy(f,abs(H(:,:,1)))
xlabel('Frequency [Hz]')
ylabel('Accelerance')
grid
title('Select lower and upper frequency range')
if nargin<7 % added MK
[xx,dum]=ginput(2);
else % added MK
xx = freqRng; % added MK
end % added MK
xx=round(xx);
fidx=find(f >= min(xx) & f <= max(xx));
fLimits=[min(xx);max(xx)];
fOffset=fLimits(1);                         % poles must be adjusted later
close(h)

% Calculate MIF function if MifType is a string, otherwise put vector into
% MIF variable
if ischar(MifType)   | isempty(MifType)             % Added to support empty MifType 2017-11-29
    if isempty(MifType) | strcmp(MifType,'DEFAULT')
        MIF=amif(H);
    else
        MIF=amif(H,MifType);
    end
else
    MIF=MifType;
end

% Integrate accelerances to receptance and reduce to selected freqs
H=fint(H(fidx,:,:),f(fidx),'lin',2);
f=f(fidx);
MIF=MIF(fidx,:);

if CondHmtrx == 1
    if SelNoSingVal == 1
        H=enhancefrf(H,'manual');
    else
        H=enhancefrf(H,'auto');
    end
end

% Calculate impulse responses for selected frequency range
[h,t,fs] = frf2ir(H,f);
[N,D,R]=size(h);

[p,L] = ir2ptime(h,fs,Nlines,MaxModes,EstType,MIF,f,fOffset);


