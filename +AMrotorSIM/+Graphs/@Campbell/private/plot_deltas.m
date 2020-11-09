function plot_deltas( ax,rpm,EW,color )
% Plots the negative real part of the eigenvalue in the diagram (decay constant)
%
%    :parameter ax: Axes properties control of the figure (check matlab function: axes)
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rpm: Rotation speed
%    :type rpm: vector
%    :parameter EW: Eigenvalues
%    :type EW: vector
%    :parameter color: Color in RGB
%    :type color: vector
%    :return: Campbell diagram with negative real part of the eigenvalue (damping) over rotation speed

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    plot(ax,rpm,-real(EW),...
              'Color',color)

end

