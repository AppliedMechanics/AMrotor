function [ m, b ] = linegradient( x_1, y_1, x_2, y_2 )
% Provides the gradient between two nodes of the geometry in the plane
%
%    :parameter x_1: 1st coordinate of the 1st node
%    :type x_1: double
%    :parameter y_1: 2nd coordinate of the 1st node
%    :type y_1: double
%    :parameter x_2: 1st coordinate of the 2nd node
%    :type x_2: double
%    :parameter y_2: 2nd coordinate of the 2nd node
%    :type y_2: double
%    :return: Gradient (m) and offset (b) 

% Licensed under GPL-3.0-or-later, check attached LICENSE file

m = (y_2 - y_1) / (x_2 - x_1);
b = (x_1*y_2 - x_2*y_1) / (x_1 - x_2);
end

