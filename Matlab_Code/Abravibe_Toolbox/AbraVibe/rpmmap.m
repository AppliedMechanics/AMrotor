function [S,F,R] = rpmmap(x,fs,rpm,trpm,MinRpm,MaxRpm,DeltaRpm,Win,PhaseRef)
% RPMMAP    Compute rpm/frequency spectral map for order tracking, fixed fs
%
%       [S,F,R] = rpmmap(x,fs,rpm,trpm,MinRpm,MaxRpm,DeltaRpm,Win,PhaseRef)
%
%       S           Linear spectra, see Method
%       F           Frequency axis for S
%       R           RPM axis for S
%
%       x           Time signal in column vector
%       fs          Sampling frequency for x
%       rpm         RPM signal, see TACHO2RPM
%       trpm        Time axis for rpm
%       MinRpm      Minimum RPM for map
%       MaxRpm      Maximum RPM for map
%       DeltaRpm    RPM step for map
%       Win         Time window with FFT size in column vector, e.g. ahann(8*1024)
%       PhaseRef    (Optional) signal for phase reference (for example
%                   tacho signal). MUST have same time axis as x
%
% S is produced using linear spectrum and the time window defined by Win.
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
%          1.1 2013-02-02
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin < 8
    error('Too few input parameters')
end

N=length(Win);          % FFT blocksize

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
TargetIdx=TargetIdx(find(TargetIdx < length(x)-N/2));

%========================================================================
% Compute linear spectra at these target indeces
S=zeros(N/2+1,length(TargetIdx));
F=zeros(length(TargetIdx),1);
R=zeros(1,length(TargetIdx));
for n = 1:length(TargetIdx)
    xt=x(TargetIdx(n)-N/2+1:TargetIdx(n)+N/2);
    MeanRpm(n)=mean(rpm(TargetIdx(n)-N/2+1:TargetIdx(n)+N/2));
    if n == 1
        [S(:,n),F]=alinspec(xt,fs,Win,1);
    else
        S(:,n)=alinspec(xt,fs,Win,1);
    end
    R(n)=rpm(TargetIdx(n));    % changed 02-02-13 to ensure R same length as dim 2 in S
end

% R=TargetRpm;                 % Deactivated 02-02-13
% R=R(find(R >= min(rpmav) & R <= max(rpmav)));

% If phase reference is given, add phase relative to this signal
if exist('PhaseRef','var')         % Phase reference given
    for n = 1:length(TargetIdx)
        xt=x(TargetIdx(n)-N+1:TargetIdx(n));
        rt=PhaseRef(TargetIdx(n)-N+1:TargetIdx(n));
        Pspec(:,n)=alinspecp(xt,rt,fs,Win,1);
        S(:,n)=S(:,n).*exp(j*angle(Pspec(:,n)));
    end
end

