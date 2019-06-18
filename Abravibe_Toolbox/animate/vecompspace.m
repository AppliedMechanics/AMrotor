function y = vecompspace(d1, d2, n)
%VECOMPSPACE
%	Y = vecompspace(D1, D2, N)
%
%	Creates equally space vector from D1 to D2 with N intervals for complex
%		vectors D1 and D2.  Not sure if I should use real(d1) & real(d2) or
%		abs(d1) & abs(d2) with phase.  Currently using magnitude
%
%
% Dan Lazor  UCSDRL
% 9/19/00
%

if nargin == 2
    n = 100;
end

%phasevector=linspace(0,2*pi+(2*pi)/n,n);
phasevector=linspace(0,2*pi-(2*pi)/n,n);

for ii=1:size(d1,1)
       y(ii,:) = d1(ii)*cos(d2(ii)+phasevector);
end

