function M = amoment(x,n);
%AMOMENT    Calculate statistical moment
%
%           M = amoment(x,n);
%
%           M           Central moment of order n (mean of x removed)
%
%           x           Time signal(s), in column(s)
%           n           Statistical order (2 for variance, ...)


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


m=mean(x);
M=zeros(1,length(m));
for col=1:length(m)
   M(col)=mean((x(:,col)-m(col)).^n);
end
