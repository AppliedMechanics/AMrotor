function [h,t,fs] = frf2ir(H,f);
% FRF2IR    Convert freqency response(s) to impulse response(s)
%
%           [h,t,fs] = frf2ir(H,f);
%       
%           H           Single-sided frequency response(s) in column(s),
%                       size N/2+1-by-D-by-R
%           f           Frequency axis for H
%
%           h           Impulse response(s) in column(s), size N-D-R
%           t           Time axis for h
%           N           Original blocksize to produce H
%           D           Number of responses
%           R           Number of references (forces)
%
% This function creates impulse response(s) from a single-sided frequency
% response (or responses if H contains more than one column). It is assumed
% that H contains frequencies from 0 to fs/2. If the original blocksize to
% produce H was N, then H must have length N/2+1.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Find size of H 
[Nt,D,R]=size(H);
N=2*(Nt-1);             % NOTE! This only works if length(H)=N/2+1
df=f(2)-f(1);
fs=N*df;

% Define output h matrix
h=zeros(N,D,R);

% Loop through each 
for r = 1:R
    for d = 1:D
        if R == 1
            H2=fnegfreq(H(:,d),'fft');
            h(:,d)=fs*real(ifft(H2));
        else
            H2=fnegfreq(H(:,d,r),'fft');
            h(:,d,r)=fs*real(ifft(H2));
        end
    end
end

if nargout >= 2
    t=makexaxis(h,1/fs);
end