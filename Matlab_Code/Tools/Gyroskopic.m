clear all
close all

m=2;
L=1;
Ixx=1.5;
I=0.05;
k=100;

Omega=0:10;

for n=1:length(Omega)

M=[m+I/L^2,0;0,m+I/L^2];
G=[0,Omega(n)*Ixx/L^2;-Omega(n)*Ixx/L^2,0];
K=[k,0;0,k];
zero=[0,0;0,0];

A=[M,zero;zero,K];
B=[G,K;-K,zero];

% [V(:,:,n),lambda0]=polyeig(K,G*0,M);
% lambda(:,n)=(lambda0);

[V(:,:,n),lambda0]=eig(B,A);
lambda(:,n)=diag(lambda0);
winkel(:,:,n)=360*angle(V(:,:,n))/(2*pi);
kriterium(:,:,n)=sign(winkel(1,:,n)-winkel(2,:,n));
% Wenn Kriterium +1, dann Gleichlauf, wenn Kriterium gleich -1 dann
% Gegenlauf! Für jeden Punkt individuell berechenbar!
end

figure()
plot(imag(lambda'))