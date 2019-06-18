function y = timeweight(x,fs,Type)
% TIMEWEIGHT   Filter data with time weighting filter in time domain
%
%       y = timeweight(x,fs,Type)
%
%       y       Filtered output signal(s) in vectors
%
%       x       Input data vector(s) in columns
%       fs      Sampling frequency for x (and y)
%       Type    'A' acoustic A-weighting
%               'C' acoustic C-weighting
%
%   This command upsamples data 4 times, performs filtering, and then
%   downsamples again, to conveniently improve accuracy.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Type=upper(Type);

% Upsample data 4 times
fsn=4*fs;

if strcmp(Type,'A')
    [B,A]=afcoeff(fsn,'A');
elseif strcmp(Type,'C')
    [B,A]=afcoeff(fsn,'C');
else
    error('Unsupported filter type!')
end

% Filter data on upsampled version
[N,M]=size(x);
y=zeros(N,M);
for n=1:M
    xt=resample(x(:,n),fsn,fs);
    yt=filter(B,A,xt);
    y(:,n)=resample(yt,fs,fsn);
end

