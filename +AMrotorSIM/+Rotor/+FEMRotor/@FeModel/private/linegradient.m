% Licensed under GPL-3.0-or-later, check attached LICENSE file

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

syms m_1
syms b_1
eqn_1 = y_1-x_1*m_1 == y_2-x_2*m_1;
m= vpasolve(eqn_1, m_1);

eqn_2 = y_1 == m*x_1+b_1;
b = vpasolve(eqn_2, b_1);
end

