function H = modal2frfh(f,fr,etar,V,indof,outdof,Type)
% MODAL2FRFH  Synthesize FRF(s) from modal parameters with hysteretic damping
%
%       H = modal2frfh(f,fr,etar,V,,indof,outdof,Type)
%
%       H           FRF matrix, N-by-D-by-R
%
%       f           Frequency axis (column) vector
%       fr          Column vector with natural frequencies in Hz, one for each column in V
%       etar        Column vector with hysteretic damping, one for each column in V
%       V           Mode shape matrix with modes in columns (unity modal mass)
%       indof       Vector with dofs for references (inputs), length=R
%       outdof      Vector with dofs for responses (outputs), length=D,
%                   Default is 1:length(V(:,1))
%       Type        String with 'd' for dynamic flexibility (displacement/force)
%       	        String with 'v' for mobility (velocity/force) (Default)
%       	        String with 'd' for accelerance(acceleration/force)
%       N           length(f), number of frequency values to compute H on
%
% Note: For all modes, only one mode shape and pole out of every
% complex conjugate pair should be included in p and V. The complex
% conjugate is produced by this function. fr, etar, and V must correspond, 
% that is, the number of columns in V must be = length(fr)=length(etar).
%
% Note2: The mode shapes are assumed to be scaled to unity modal A.
%
% Example:
% H = modal2frf(f,fr,etar,V,[1 3],[1:12],'v') produces a 3D matrix H (mobilities)
% (N-by-12-by-3), provided length(V(:,1)) is >= 12. fr, etar, and V do not need to
% include all modes of the system (but of course, then the FRFs are not
% complete).

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if fr(1) == 0
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

% calculate j*omega
w2=-(2*pi*f).^2;
wr=2*pi*fr;

% Allocate H
N=length(f);
D=length(outdof);
R=length(indof);
Nm=length(fr);
H=zeros(N,D,R);
% Loop through all inputs
for inno = 1:R
    % Loop through response dofs
    for outno = 1:D
        % Loop through modes
        for mode = 1:Nm
            % Calculate residue. NOTE!  modes scaled to unity modal A
            R=V(inno,mode)*V(outno,mode);
            % Compute dynamic flexibility
            H(:,outno,inno)=H(:,outno,inno)+R./(w2+wr(mode)^2 +j*etar(mode));
        end
        if strcmp(Type,'V')
            H(:,outno,inno)=fdiff(H(:,outno,inno),f,'lin',1);
        elseif strcmp(Type,'A')
            H(:,outno,inno)=fdiff(H(:,outno,inno),f,'lin',2);
        end
    end
end
