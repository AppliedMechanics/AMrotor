function [B,A] = afcoeff(fs,Type)
% AFCOEFF  Compute filter coefficients for time domain filters
%
%       [B,A] = afcoeff(fs,Type)
%
%       B       Digital filter B coefficients, see FILTER
%       A       Ditto A coefficients
% 
%       fs      Sampling frequency for data
%       Type    'A' for acoustic A-weighting filter
%               'C' for acoustic C-weighting filter

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Type=upper(Type);

if strcmp(Type,'C')
    w1=2*pi*20.6;
    D1=conv([1 w1],[1 w1]);
    jw1k=j*2*pi*1000;
    C1=abs(jw1k+w1)^2/abs(jw1k)^2;
    w2=2*pi*12200;
    D2=conv([1 w2],[1 w2]);
    C2=abs(jw1k+w2)^2;
    [B1,A1]=bilinear([C1 0 0],D1,fs);
    [B2,A2]=bilinear(C2,D2,fs);
    B=conv(B1,B2);
    A=conv(A1,A2);
elseif strcmp(Type,'A')
    [B,A]=afcoeff(fs,'C');
    w3=2*pi*107.7;
    w4=2*pi*737.9;
    D3=conv([1 w3],[1 w4]);
    jw1k=j*2*pi*1000;
    C3=abs(jw1k+w3)*abs(jw1k+w4)/abs(jw1k)^2;
    [B1,A1]=bilinear([C3 0 0],D3,fs);
    B=conv(B,B1);
    A=conv(A,A1);
end

% For later: D-weighting poles and zeros are
%         Poles             Zeroes
%     -282.7 + j0       -519.8 + j876.2
%      -1160 + j0       -519.8 - j876.2
%      -1712 + j2628         0 + j0
%      -1712 - j2628
