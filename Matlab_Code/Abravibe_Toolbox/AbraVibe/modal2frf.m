function H = modal2frf(f,p,V,indof,outdof,Type)
% MODAL2FRF  Synthesize FRF(s) from modal parameters
%
%       H = modal2frf(f,p,V,indof,outdof,Type)
%
%       H           FRF matrix, N-by-D-by-R
%
%       f           Frequency axis (column) vector
%       p           Column vector with poles, one for each column in V
%       V           Mode shape matrix with modes in columns (unity modal A)
%       indof       Vector with dofs for references (inputs), length=R
%       outdof      Vector with dofs for responses (outputs), length=D,
%                   Default is 1:length(V(:,1))
%       Type        String with 'd' for dynamic flexibility (displacement/force)
%       	        String with 'v' for mobility (velocity/force) (Default)
%       	        String with 'a' for accelerance (acceleration/force)
%       N           length(f), number of frequency values to compute H on
%
% Note: For all modes, only one mode shape and pole out of every
% complex conjugate pair should be included in p and V. The complex
% conjugate is produced by this function. p and V must correspond, that is,
% the number of columns in V must be = length(p).
%
% Note2: The mode shapes are assumed to be scaled to unity modal A.
%
% Example:
% H = modal2frf(f,p,V,[1 3],[1:12],'v') produces a 3D matrix H (mobilities)
% (N-by-12-by-2), provided length(V(:,1)) is >= 12. p and V do not need to
% include all modes of the system (but of course, then the FRFs are not
% complete).
%
% See also UMM2UMA 

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if p(1) == 0
    error('Rigid body modes are not allowed!')
end

if nargin <= 3
    error('indof needs to be specified!')
elseif nargin == 4
    outdof = 1:length(V(:,1));
    Type='V';
elseif nargin == 5
    Type='V';
else
    Type=upper(Type);
end

% Calculate wd for mode scaling
wd=imag(p);
% calculate j*omega
jw=j*2*pi*f;

% Allocate H
N=length(f);
D=length(outdof);
R=length(indof);
Nm=length(p);
H=zeros(N,D,R);
% Loop through all inputs
for inno = 1:R
    % Loop through response dofs
    for outno = 1:D
        % Loop through modes
        for mode = 1:Nm
            % Calculate residue. NOTE!  Modes scaled to unity modal A
            A=V(indof(inno),mode)*V(outdof(outno),mode);
            % Compute dynamic flexibility
            H(:,outno,inno)=H(:,outno,inno)+A./(jw-p(mode))+conj(A)./(jw-conj(p(mode)));
        end
        if strcmp(Type,'V')
            H(:,outno,inno)=fdiff(H(:,outno,inno),f,'lin',1);
        elseif strcmp(Type,'A')
            H(:,outno,inno)=fdiff(H(:,outno,inno),f,'lin',2);
        end
    end
end

