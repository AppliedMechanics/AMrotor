function status = teststat(y,alfa,Type)
%TESTSTAT Hypothesis test for stationarity
%
%       status = teststat(F,alfa,Type);
%
%       status      Logical variable(s) = 1 (true) if signal in x is
%                   stationary with significance level alfa
%
%       F           Frames from FRAMESTAT
%       alfa        Significance level
%       Type        'reverse' performs a reverse arrangements test,
%                   sensitive to trends in (columns of) x
%                   'runs' performs a run test, sensitive to periodicity
%                   in (columns of) x
%
%
%   See also STATCHK FRAMESTAT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Type=upper(Type);
N=length(y);

% If more than one channel (column) in x, loop trough each channel
%
%     % First, calculate the parameters yi for either test type
%     L=floor(length(x(:,ch))/N);
%     for n=0:N-1,
%         y(n+1)=feval(func,x(n*L+1:(n+1)*L,ch));
%     end
% Analysis dependent on test type
if strcmp(Type,'REVERSE')
    
    % Next calculate the A number by summing up Ai
    A=0;
    for n=2:length(y)
        A=A+sum(y(n-1) > y(n:end));
    end
    
    % Calculate the upper and lower limits for the hypothesis to hold
    mu=N*(N-1)/4;
    s=sqrt(N*(2*N+5)*(N-1)/72);
    
elseif strcmp(Type,'RUNS')
    
    % Produce the run variable r as 1 and 0 instead of + and -
    r=(y >= mean(y));
    % Count number of runs
    d=diff(r);
    A=1+sum(abs(d));
    
    N1=sum(r);
    N2=N-N1;
    
    %    N=N/2;      % Only half degrees of freedom
    mu=2*N1*N2/(N)+1;
    s=sqrt((mu-1)*(mu-2)/(N-1));
    %    s=sqrt(2*N1*N2/N^2*(2*N1*N2-N)/(N-1))
end

% Null hypothesis decision is independent of test type
delta=sqrt(2)*erfinv(1-alfa);
lo_lim=fix(mu-delta*s);
hi_lim=fix(mu+delta*s);
status = (lo_lim<A) && (hi_lim>A);

