% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plotMode( axFigure, x, V, D , color)
% Formats the figure for 2D visualization of the mode shapes
%
%    :param axFigure: Axes properties control of the figure
%    :type axFigure: matlab.graphics.axis.Axes object
%    :param x: Position of the eigenvector along z-axis
%    :type x: double
%    :param V: Eigenvector
%    :type V: vector
%    :param D: Eigenvalue
%    :type D: double
%    :param color: Color
%    :type color: char
%    :return: Notification of object name

%PLOTMODE 
% plotMode( axFigure, x, V, D , color)

plot(axFigure,x,V,...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)),...
            'Color',color)
xlabel('position')
ylabel('amplitude')

end

