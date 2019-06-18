function [p,V] = mkz2modal(M,K,z)
% MKZ2MODAL     Compute modal model (poles and mode shapes) from M,K, and z
%
%       [p,V] = mkz2modal(M,K,z)
%
%       p       Column vector with poles, (or eigenfrequencies if undamped) in rad/s
%       V       Matrix with mode shapes in columns
%       
%       M       Mass matrix
%       K       Stiffness matrix
%       z       Vector with (viscous) relative damping of each mode
%
% NOTE: The list of poles is limited to the poles with positive imaginary
% part, as the other half of the poles can easily be calculated as the
% complex conjugates of the first ones.
%
% Mode shape scaling:
% Mode shapes are scaled to unity modal A. 
% This means that the modal scaling constant, Qr = 1, that is, that all 
% residues are Apqr=psi_pr*psi_qr
% This also means that the mode shapes are complex even for the
% proportionally damped case.
%
% See also UMA2UMM

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Solve for mode shapes and undamped poles
[pu,V]=mck2modal(M,K);
pu=pu(:);
z=z(:);                         % To ensure same dimensions
p=-z.*imag(pu)+pu.*sqrt(1-z.^2);
% Rescale mode shapes to unity modal A, see mck2modal
V=umm2uma(V,p);

