function C = acrest(x);
%ACREST Calculate crest factor
%
%       C = acrest(x);
%
%       C           Crest factor (max(abs(x)) over std(x))
%
%       x           Time data, if more than one column, each column is
%                   computed and S is a row vector
%
% See also APDF AMOMENT STATCHK FSTATCHK

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Sigma=std(x);
C=max(abs(x))./(Sigma);
