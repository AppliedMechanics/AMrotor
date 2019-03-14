function Y = fint(X,f,Type,NumberInt)
%FINT Frequency integration by jw division
%
%       Y = fint(X,f,Type,NumberInt)
%
%       Y           Integrated spectrum (multiplied once or twice by jw)
%                   Y can be up to 3 dimensions (for example for FRF
%                   matrices)
%
%       X           Input spectrum (linear or power spectrum)
%       f           Frequency axis for G
%       Type        'lin' for linear spectrum/FRF, or 'power' for PSD, or
%                   other power spectrum. Default = 'lin'
%       NumberInt   Number of integrations, 1 (default) or 2
%
% See also FDIFF

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 2
    Type='LIN';
    NumberInt=1;
elseif nargin == 3
    Type=upper(Type);
    NumberInt=1;
elseif nargin == 4
    Type=upper(Type);
end

% Avoid division by zero
jw=j*2*pi*f;
if jw(1) == 0
    jw(1)=jw(2);
end

if strcmp(Type,'LIN')
    if NumberInt == 1
        op=1./jw;                % Operator is 1/jw
    elseif NumberInt == 2
        op=1./(jw).^2;            % Operator is 1/(jw)^2
    else
        error('Wrong parameter NumberInt! Only 1 or 2 allowed')
    end
elseif strcmp(Type,'POWER')
    if NumberInt == 1
        op=-1./(jw).^2;             % Operator is 1/w^2
    elseif NumberInt == 2
        op=1./(jw).^4;            % Operator is 1/w^4
    else
        error('Wrong parameter NumberInt! Only 1 or 2 allowed')
    end
else
    error('Wrong Type parameter! Only ''lin'' or ''power'' allowed.')
end

[N,D,R]=size(X);
Y=zeros(size(X));

for n = 1:D
    if R == 1
        Y(:,n)=X(:,n).*op;
    else
        for m=1:R
            Y(:,n,m)=X(:,n,m).*op;
        end
    end
end

Y(1,:,:)=0;

    
