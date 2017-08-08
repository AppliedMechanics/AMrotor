% Test Jacobi-Script

clear all;
close all;
clc

F_1=[1;1;1;1]
F_2=[1.2;1.3;1.4;1.5]

u_1 = [1;1;1;1]
u_2 = [2;2;2;2]

J = jacobian(F_1,F_2,u_1,u_2)