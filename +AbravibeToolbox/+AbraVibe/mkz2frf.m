function H = mkz2frf(f,M,K,z,indof,outdof,type)
%MKZ2FRF Calculate FRF(s) from M, K and modal damping, z
%
%       H = mkz2frf(f,M,K,z,indof,outdof,type)
%
%       H       Frequency response matrix in [(m/s)/N] (matrix) N-by-D-by-R
%       N       length(f), number of frequency values
%       D       length(outdof), number of responses
%       R       length(indof), number of references (inputs)
%  
%       f       Frequency vector in [Hz]
%       M       Mass matrix in [kg]
%       K       Stiffness matrix in m/N
%       z       vector with modal damping (relative damping)
%       indof   Input DOF(s), may be a vector for many reference
%               DOFs, (default = 1)
%       outdof  Output DOF(2) may be a vector for many responses
%               (default = 1)
%       type    Type of output FRF as string: 
%               'Flexibility' or 'd' generates displacement/force 
%               'Mobility' or 'v'    generates velocity/force (Default)
%               'Accelerance' or 'a' generates acceleration/force
% Example:
%    H = mkz2frf(f,M,K,z,[1 2 4],[5:12],'v');
% Calculates mobilities with columns corresponding to force in
% DOFs 1, 2, and 4, and responses in DOFs 5 to 12. H will in this case be
% of dimension (N, 8, 3) where N is the number of frequency values.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

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
elseif strcmp(upper(type),'D') | strcmp(upper(type),'V') | strcmp(upper(type),'A')
    type=upper(type);
else
    error('Wrong input type!')
end

% Find dimensions
N = length(f);
D = length(outdof);
R = length(indof);

% Ensure column vectors
z=z(:);

% Allocate H MATRIX for output
H = zeros(N,D,R);

% Main
% Solve the undamped system for natural freqs and normal modes, using
% mck2frf
[jwn,V]=mck2modal(M,K);
wn=imag(jwn);
% Compute complex poles using damping in z
p=-z.*wn+j*wn.*sqrt(1-z.^2);
% Rescale mode shapes to unity modal A because V are now scaled to unity
% modal mass, because modal2frf assumes unity modal A scaling
V=umm2uma(V,p);
% Compute requested FRFs using modal2frf
H=modal2frf(f,p,V,indof,outdof,type);


