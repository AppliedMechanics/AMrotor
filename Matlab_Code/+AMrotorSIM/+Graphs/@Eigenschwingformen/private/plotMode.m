function plotMode( axFigure, x, V, D )
%PLOTMODE Summary of this function goes here
%   Detailed explanation goes here

% find the maximum absolute value
[~,index] = max(abs(V),[],1);
% possible change sign of V so biggest amplitude is positive
V = sign(V(index))*V;
% plot
plot(axFigure,x,V/norm(V),...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)))

end

