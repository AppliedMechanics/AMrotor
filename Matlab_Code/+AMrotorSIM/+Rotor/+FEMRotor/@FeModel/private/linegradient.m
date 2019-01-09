function [ m, b ] = linegradient( x_1, y_1, x_2, y_2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

syms m_1
syms b_1
eqn_1 = y_1-x_1*m_1 == y_2-x_2*m_1;
m= vpasolve(eqn_1, m_1);

eqn_2 = y_1 == m*x_1+b_1;
b = vpasolve(eqn_2, b_1);
end

