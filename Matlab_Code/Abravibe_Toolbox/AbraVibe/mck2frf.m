function H = mck2frf(f,M,C,K,indof,outdof,type)
%MCK2FRF Calculate FRF(s) from M, C, K matrices
%
%       H = mck2frf(f,M,C,K,indof,outdof,type)
%
%               H       Frequency response matrix in [(m/s)/N] (matrix) N-by-D-by-R
%               N       length(f), number of frequency values
%               D       length(outdof), number of responses
%               R       length(indof), number of references (inputs)
%  
%               f       Frequency vector in [Hz]
%               M       Mass matrix in [kg]
%               C       Damping matrix in [Ns/m]
%               K       Stiffness matrix in m/N
%               indof   Input DOF(s), may be a vector for many reference
%                       DOFs, (default = 1)
%               outdof  Output DOF(2) may be a vector for many responses
%                       (default = 1)
%               type    Type of output FRF as string: 
%                       'Flexibility' or 'd' generates displacement/force 
%                       'Mobility' or 'v'    generates velocity/force (Default)
%                       'Accelerance' or 'a' generates acceleration/force
% Example:
%               H = mck2frf(f,M,C,K,[1 2 4],[5:12],'v');
%
% Calculates mobilities with columns corresponding to force in
% DOFs 1, 2, and 4, and responses in DOFs 5 to 12. H will in this case be
% of dimension (N, 8, 3) where N is the number of frequency values.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Code:
% Parse Input Parameters
if nargin < 4
    error('Too few input variables. At least f, M, C, and K must be used!')
elseif nargin == 4
    indof=1;
    outdof=1;
    type='V';
elseif nargin == 5
    outdof=1;
    type='V';
elseif nargin == 6
    type='V';
end

if strcmp(upper(type),'FLEXIBILITY')
    type='D';
elseif strcmp(upper(type),'MOBILITY')
    type='V';
elseif strcmp(upper(type),'ACCELERANCE')
    type='A';
elseif strcmp(upper(type),'D') || strcmp(upper(type),'V') |...
        strcmp(upper(type),'A')
    type=upper(type);
else
    error('Wrong input type!')
end

% Find dimensions
N = length(f);
D = length(outdof);
R = length(indof);

% Allocate H MATRIX for output
H = zeros(N,D,R);

% Main
% Loop through frequencies and use inverse of system impedance matrix:
% B(s)*X(s)=F(s) ==> B(s) in form of B=F/X
% H(s) = inv(B(s)) ==> X(s)/F(s), so that H(s)*F(s)=X(s)
% 
for n = 1:N         % Frequency index
    w = 2*pi*f(n);  % Omega for this frequency
    Denom = -(w^2)*M+j*w*C+K;           % Newton's equation in denominator of Hv
    InvDenom = Denom\eye(size(Denom));   % Inverse denominator, same as inv(Denom) but Gaussian elimination
    for r = 1:R
        if strcmp(type,'D')
            H(n,:,r) = InvDenom(outdof,indof(r));
        elseif strcmp(type,'V')
            H(n,:,r) = j*w*InvDenom(outdof,indof(r));
        else
            H(n,:,r) = -(w^2)*InvDenom(outdof,indof(r));
        end
    end
end


