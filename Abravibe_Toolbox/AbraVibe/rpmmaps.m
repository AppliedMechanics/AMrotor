function [S,F,R] = rpmmaps(xs,rpm,OrdRes,MaxOrd,MinRpm,MaxRpm,DeltaRpm,WinStr,PhaseRef)
% RPMMAPS    Compute rpm/order spectral map for order tracking, synchronuous sampling
%
%       [S,F,R] = rpmmaps(xs,rpm,OrdRes,MaxOrd,MinRpm,MaxRpm,DeltaRpm,WinStr,PhaseRef)
%
%       S           Linear spectra, see Method
%       F           Order axis for S
%       R           RPM axis for S
%
%       xs          Synchronuously sampled time signal, from SYNCHSAMP
%       rpm         RPM signal, output from SYNCHSAMP
%       OrdRes      Order resolution (determines FFT size together with MaxOrd)
%       MaxOrd      Maximum order to plot, the same as used for SYNCHSAMP 
%       MinRpm      Minimum RPM for map
%       MaxRpm      Maximum RPM for map
%       DeltaRpm    RPM step for map
%       WinStr      String with time window, e.g. 'aflattop'
%       PhaseRef    (Optional) signal for phase reference (for example
%                   tacho signal). MUST have same sampling as xs
%
% S is produced using linear spectrum and the time window defined by WinStr.
% If PhaseRef is given, S is a complex matrix with magnitude from spectra
% of x, and phase relative to the vector PhaseRef. If PhaseRef is not
% given, S contains linear spectra of x with no phase information.
%
% A check is made that MinRpm and MaxRpm are possible, given the data at
% hand. If not, the resulting MinRpm and MaxRpm in the map will be the
% closest possible rpm values in the sequence MinRpm:DeltaRpm:MaxRpm
% 
%
%   See also TACHO2RPM PLOTRPMMAPC


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2013-03-13 Fixed bug if PhaseRef given, indeces where wrong
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin < 8
    error('Too few input parameters')
end

% Determine FFT blocksize based on max order and order resolution
N=2*OrdRes*MaxOrd;
% Calculate time window
Win=feval(WinStr,N);

%========================================================================
% Determine start indeces of each block in x, depending on the rpm/time
% profile, and requested RPMs.
% NOTE: rpm values are taken from the average of rpm over N samples, so
% that each block has a mean rpm of the requested target

% Compute average RPM over blocksize N
Filt=1/N*ones(1,N);
rpmav=conv(rpm,Filt);
rpmav=rpmav(N:end-N+1);
% Find closest match to target RPMs
TargetRpm=[MinRpm:DeltaRpm:MaxRpm];
TargetIdx=[];
for n = 1:length(TargetRpm)
    if TargetRpm(n) <= max(rpmav) & TargetRpm(n) >= min(rpmav)
        TargetIdx=[TargetIdx N/2+round(min(find(rpmav >= TargetRpm(n))))];
    end
end
% Ensure that there are N/2 samples after each TargetIdx, so that data are
% not exhausted at the end of data
TargetIdx=TargetIdx(find(TargetIdx < length(xs)-N/2));

%========================================================================
% Compute linear spectra at these target indeces
S=zeros(N/2+1,length(TargetIdx));
F=zeros(length(TargetIdx),1);
R=zeros(1,length(TargetIdx));
for n = 1:length(TargetIdx)
    xt=xs(TargetIdx(n)-N/2+1:TargetIdx(n)+N/2);
    if n == 1
        [S(:,n),F]=alinspec(xt,2*MaxOrd,Win,1);
    else
        S(:,n)=alinspec(xt,2*MaxOrd,Win,1);
    end
%     R(n)=rpm(TargetIdx(n));
end
R=TargetRpm;
R=R(find(R >= min(rpmav) & R <= max(rpmav)));

% If phase reference is given, add phase relative to this signal
if exist('PhaseRef','var')         % Phase reference given
    for n = 1:length(TargetIdx)
        xt=xs(TargetIdx(n)-N/2+1:TargetIdx(n)+N/2);         % Changed 2013-03-13
        rt=PhaseRef(TargetIdx(n)-N/2+1:TargetIdx(n)+N/2);   % Changed 2013-03-13
        Pspec(:,n)=alinspecp(xt,rt,2*MaxOrd,Win,1);
        S(:,n)=S(:,n).*exp(j*angle(Pspec(:,n)));
    end
end

