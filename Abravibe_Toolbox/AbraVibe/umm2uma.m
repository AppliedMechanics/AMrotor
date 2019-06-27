function V = umm2uma(Vold,p)
% UMM2UMA   Rescale mode shapes from unity modal mass to unity modal A
%
%       V = umm2uma(Vold,p)
%
%       V       New mode shapes with unity modal A scaling
%
%       Vold    Old mode shapes with unity modal mass scaling, as from, e.g.,
%               MCK2MODAL for undamped system, mode shapes in columns
%       p       poles, same size as V
%
% See also UMA2UMM

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if length(p) ~= length(Vold(1,:))
    error('Wrong sizes! length(p) ~= length(Vold(1,:))')
end

for n = 1:length(p)
    wd=imag(p(n));
    V(:,n)=Vold(:,n)/sqrt(j*2*wd);
end