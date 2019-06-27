function V = uma2umm(Vold,p)
% UMA2UMM   Rescale mode shapes from unity modal A to unity modal mass
%
%       V = uma2umm(Vold,p)
%
%       V       New mode shapes with unity modal mass scaling
%
%       Vold    Old mode shapes with unity modal A scaling, as from, e.g.,
%               MCK2MODAL, mode shapes in columns
%       p       poles, same size as V
%
% See also MCK2MODAL UMM2UMA

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if length(p) ~= length(Vold(1,:))
    error('Wrong sizes! length(p) ~= length(V(1,:))')
end

for n = 1:length(p)
    wd=imag(p(n));
    V(:,n)=Vold(:,n)*sqrt(j*2*wd);
end