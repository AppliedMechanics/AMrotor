function [y,H,f] = fresppv(x,fs,p,V,indof,outdof)
% FRESPPV   Time domain filter forced response. Internal function.
%
%       y = fresppv(x,fs,M,C,K,indof,outdof)
%
%       y       Output displacement
%       H       Frequency response of filters (for error check)
%       f       Frequency axis for H
%
%       x       Input force(s)
%       fs      Sampling frequency
%       p       Poles
%       V       Mode shapes, scaled to unity modal A
%       indof   dofs for x
%       outdof  dofs for y

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-11-11 Fixed output of H and f

% This file is part of ABRAVIBE Toolbox for NVA

% This routine does NOT upsample, it just calculates the output
% displacement based on one or more forces. It uses ramp invariant
% transform.

% Reference:
% Ahlin, K., Magnevall, M. & Josefsson, A., "Simulation of forced response 
% in linear and nonlinear mechanical systems using digital filters,", ISMA, 
% International Conference on Noise and Vibration Engineering, Catholic 
% University, Leuven, 2006.

% Check input variables
[N,R]=size(x);
D=length(outdof);
dt=1/fs;
NoModes=length(p);
Nh=64*1024+1;               % Block size for H output

% Allocate output matrix/matrices
y=zeros(N,D);
if nargout > 1
    H=zeros(Nh,D,R);
end

% Calculate output signals for each output dof
for d = 1:D
    resp=outdof(d);
    for r = 1:R
        ref=indof(r);
        for k = 1:NoModes
            % Calculate filter parameters
            Res=V(ref,k)*V(resp,k);
            Denom=[1 -exp(p(k)*dt)];
            Numer=Res/(p(k)^2*dt)*[-p(k)*dt-1+exp(p(k)*dt) 1+p(k)*dt*exp(p(k)*dt)-exp(p(k)*dt)];
            B=2*conv(real(Numer),real(Denom))+2*conv(imag(Numer),imag(Denom));
            A=real(conv(Denom,conj(Denom)));
            % Filter input indof and add to output outdof, for this mode
            % contribution
            y(:,d)=y(:,d)+filter(B,A,x(:,r));
            % If H is requested as output argument, save filter
            % coefficients for all modes
            if nargout > 1
                Bs(k,:)=B;
                As(k,:)=A;
            end
        end
        % If H is requested, synthesize the frequency response using Nh
        % blocksize
        if nargout > 1
            for k = 1:NoModes
                [Ht,f]=freqz(Bs(k,:),As(k,:),Nh,fs);
                H(:,d,r)=H(:,d,r)+Ht;
            end
        end
    end
end

