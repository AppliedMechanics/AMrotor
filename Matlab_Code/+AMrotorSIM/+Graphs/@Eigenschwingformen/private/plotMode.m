function plotMode( axFigure, x, V, D )
%PLOTMODE Summary of this function goes here
%   Detailed explanation goes here

plot(axFigure,x,V/norm(V),...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)))

end

