function DofString = headpstr(Header)
% HEADPSTR     Create string out of Abravibe header Dof and Dir info
%
%       DofString = headpoint(Header)
%
%       DofString       String with Dof number and direction, e.g. '32Y-'
%                       for single measurement, or '32Y-/12X+' for
%                       multi-point measurement (e.g. FRF)
%
%       Header          Abravibe header struct

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if isfield(Header,'RefDof')
    if Header.RefDof == 0
        DofString=strcat(int2str(Header.Dof),Header.Dir);
    else
        DofString=strcat(int2str(Header.Dof),Header.Dir,'/',int2str(Header.RefDof),Header.RefDir);
    end
else
    DofString=strcat(int2str(Header.Dof),Header.Dir);
end
