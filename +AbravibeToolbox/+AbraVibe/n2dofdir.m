function    [Dof,nDir] = n2dofdir(nDof)
% N2DOFDIR  Convert dof numeric format to dof number and numeric dir  
%
%           [Dof,nDir] = n2dofdir(nDof)
%
%           Dof         Point number, vector if nDof is vector
%           Dir         Numeric direction, vector if nDof is vector
%
%           nDof        Numeric dof/dir number, where last number is
%                       direction, and sign(nDof) is the sign of dir
%
% Example:
% n2dofdir2n(-132) returns [13,-2]
%
% See also 

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Dof=abs(round(nDof/10));
nDir=sign(nDof).*(abs(nDof)-10*round(abs(nDof)/10));

