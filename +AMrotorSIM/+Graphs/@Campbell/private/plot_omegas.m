% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_omegas(ax,rpm,EW,color)
% Plots the imaginary part of the eigenvalue in the campbell diagram (damped angular eigenfrequencies omega_d)
%
%    :parameter ax: Axes properties control of the figure (check matlab function: axes)
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rpm: Rotation speed
%    :type rpm: vector
%    :parameter EW: Eigenvalues
%    :type EW: vector
%    :parameter color: Color in RGB
%    :type color: vector
%    :return: Campbell diagram with imaginary part of the eigenvalue (omega) over rotation speed

    plot(ax,rpm,imag(EW)/2/pi,...
              'Color',color)

end

