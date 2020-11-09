function x0 = get_zero_crossing(self,omega,y)
% Extracts the smallest zero crossing of omega and y (y is Eigenvalue depending on the application)
%
%    :parameter omega: Angular velocity
%    :type omega: vector
%    :parameter y: Eigenvalue variable (real, imag, ...)
%    :type y: vector
%    :return: Smallest zero crossing (x0)

% finds all zero crossings, but only returns the smallest value
% 
% Predominantly used for the damping ration over rpm to detremine the zero
% crossing of the damping to find the stability limit of the system
% 
% x0 = get_zero_crossing(self,x,y)
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

x0=[];
i=find(diff(sign(y))<0); % Uebergang von positiv zu negativen Werten

for k=1:length(i)
    itmp=i(k);
    x0tmp = interp1(y(itmp:itmp+1),omega(itmp:itmp+1),0);
    x0(end+1)=x0tmp;
end

% nur den kleinsten Wert behalten
x0=min(x0);

if isempty(x0)
    x0=NaN;
end
end

