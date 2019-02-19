function Y = fdiff(X,f,Type,NumberDiff)
%FDIFF Frequency differentiation by jw multiplication
%
%       Y = fdiff(X,f,Type,NumberInt)
%
%       Y           Differentiated spectrum (multiplied once or twice by jw)
%                   Y can be up to 3 dimensions (for example for FRF
%                   matrices)
%
%       X           Input spectrum (linear or power spectrum)
%       f           Frequency axis for G
%       Type        'lin' for linear spectrum/FRF, or 'power' for PSD, or
%                   other power spectrum. Default = 'lin'
%       NumberDiff  Number of differentiations, 1 (default) or 2
%
% See also fint

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 2
    Type='LIN';
    NumberDiff=1;
elseif nargin == 3
    Type=upper(Type);
    NumberDiff=1;
elseif nargin == 4
    Type=upper(Type);
end

if strcmp(Type,'LIN')
    if NumberDiff == 1
        op=j*2*pi*f;                % Operator is jw
    elseif NumberDiff == 2
        op=-(2*pi*f).^2;            % Operator is (jw)^2
    else
        error('Wrong parameter NumberDiff! Only 1 or 2 allowed')
    end
elseif strcmp(Type,'POWER')
    if NumberDiff == 1
        op=(4*pi*f).^2;             % Operator is w^2
    elseif NumberDiff == 2
        op=-(4*pi*f).^4;            % Operator is w^4
    else
        error('Wrong parameter NumberDiff! Only 1 or 2 allowed')
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

    

    
