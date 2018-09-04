E=211e9;
rho=7446;
d=5e-3;
l=0.5;

A=0.25*d^2*pi;
I=A/4*1/4*d^2;

lambda=3.54;

omega_1=lambda*sqrt(E*I/(rho*A*l^4));
f_1=omega_1/2/pi;