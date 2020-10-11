% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_damping_ratio(ax,rpm,EW,color)
% Plots the damping ratio into the campell diagram
%
%    :parameter ax: Axes properties control of the figure (check matlab function: axes)
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rpm: Rotation speed
%    :type rpm: vector
%    :parameter EW: Eigenvalues
%    :type EW: vector
%    :parameter color: Color in RGB
%    :type color: vector
%    :return: Campbell diagram with damping ratio over rotation speed

    plot(ax,rpm,-real(EW)./imag(EW),...
              'Color',color)

end

