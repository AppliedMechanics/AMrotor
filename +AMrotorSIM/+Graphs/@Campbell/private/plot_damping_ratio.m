% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_damping_ratio( ax,x,y,color )
% Plots the damping ratios into the diagram
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter x: Omega ???????
%    :type x: vector ??????????
%    :parameter y: Eigenvalues ???????
%    :type y: vector ?????????ß
%    :parameter color: Color
%    :type color: ???????????
%    :return: Curves of the damping ratios

    plot(ax,x,-real(y)./imag(y),...
              'Color',color)

end

