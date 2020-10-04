% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_omegas(ax,rpm,EW,color)
% Plots the angular eigenfrequencies omega in the diagram
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rpm: Rotation speed
%    :type rpm: vector
%    :parameter EW: Eigenvalues
%    :type EW: vector
%    :parameter color: Color
%    :type color: ???????????
%    :return: Curves of the angular eigenfrequencies omega

    plot(ax,rpm,imag(EW)/2/pi,...
              'Color',color)

end

