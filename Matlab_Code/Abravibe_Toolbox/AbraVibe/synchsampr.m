function  [xs,rpm,tc,tt] = synchsampr(x,fs,rpm,MaxOrd)
% SYNCHSAMPR   Resample data synchronously with RPM, using rpm-time profile
%
%       [xs,rpms,ts] = synchsampr(x,fs,rpm,MaxOrd)
%
%       xs          Synchronously sampled data
%       rpms        rpm values synchronous with samples in xs
%       ts          x axis for xs in cycles
%       t           x axis for xs in seconds
%
%       x           Time data
%       fs          Sampling frequency for x
%       rpm         Instantaneous RPM, sampled with fs
%       MaxOrd      Maximum order (gives number of samples per
%                   revolution)
%
%   see also TACHO2RPM SYNCHSAMPT RPMMAPS MAP2ORDER


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2013-02-02 Updated syntax description
% This file is part of ABRAVIBE Toolbox for NVA

SampPerRev=2*MaxOrd;

% Upsample x and rpm
x=resample(x,10,1);
t1=makexaxis(rpm,1/fs);
fs=10*fs;
t2=makexaxis(x,1/fs);
% dt=t2(2)-t2(1);
dt=t1(2)-t1(1);
% Now calculate the instantaneous angle as function of time (in part of rev,
% not radians!)
Ainst=dt*cumsum(rpm/60);         

% Find every 1/SampPerRev of a cycle in Ainst
minA=min(Ainst);
maxA=max(Ainst);
Fractions=ceil(minA*SampPerRev)/SampPerRev:1/SampPerRev:maxA;
tt=interp1(Ainst,t1,Fractions,'linear','extrap');     % New sampling times

% Now resample x on this new time axis
xs=interp1(t2,x,tt)';
% Recalculate the rpm values onto xaxis of xrs (i.e. tt)
rpm=interp1(t1,rpm,tt)';

tc=Fractions;           % Output cycles axis
