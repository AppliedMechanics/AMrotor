function poles = fz2poles(fr,zr)
% FZ2POLES Convert frequencies and damping to poles
%
%       poles = fz2poles(fr,zr)
%
%       poles       Complex poles in column vector
%
%       fr          Undamped natural (eigen-) frequencies, in vector
%       zr          Relative damping ratios, in vector same length as fr

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

fr=fr(:);
zr=zr(:);
wr=2*pi*fr;
poles=-zr.*wr+j*wr.*sqrt(1-zr.^2);