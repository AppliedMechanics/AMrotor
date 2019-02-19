function h = plotmagph(f,H,col);
%PLOTMAGPH Plot complex data in magnitude/phase format
%
%           h = plotmagph(f,H,col);
%
%           h       Handle to figure
%
%           f       Frequency axis as column vector
%           H       Complex function(s) (usually frequency response) in columns
%           col     Color string, see PLOT
%
% h=plotmagph(f,H)      returns the handle in variable h
% plotmagph(f,H)        plots in current figure
%
% H must be maximum two dimensions. Magnitude is plotted as semilogy.
%
% See also PLOTREIM


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


if nargout == 0
else
    h=figure;
end

if nargin == 1
    H=f;
    f=1:length(H(:,1));
    subplot(2,1,1)
    semilogy(f,abs(H));
    ylabel('Magnitude');
    grid on
    subplot(2,1,2);
    plot(f,angledeg(H));
    ylabel('Phase [Degrees]');
    grid on
elseif nargin == 2
    subplot(2,1,1);
    semilogy(f,abs(H));
    ylabel('Magnitude');
    grid on
    subplot(2,1,2);
    plot(f,angledeg(H));
    ylabel('Phase [Degrees]');
    grid on
elseif nargin == 3
    subplot(2,1,1);
    semilogy(f,real(H),col);
    ylabel('Magnitude');
    grid on
    subplot(2,1,2);
    plot(f,imag(H),col);
    ylabel('Phase [Degrees]');
    grid on
else
    error('Wrong number of input parameters!')
end
