% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_harmonic( ax,rpm )
% Plots the first harmonic in the diagram
%
%    :parameter ax: Axes properties control of the figure (check matlab function: axes)
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rpm: Rotation speed
%    :type rpm: vector
%    :return: Dashed line of the first harmonic
   
    plot(ax,rpm,rpm/60,'Color','black','LineStyle','--');

end

