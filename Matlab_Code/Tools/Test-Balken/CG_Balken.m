clear; home; close all;
%% init of parameters
% material
rho = 7446;
E = 211e9;
nu = 0.3;
G = 1/2/(1+nu)*E;
% geometry
R = 0.05;
r = 0;
A = pi*(R^2-r^2);
L = 1;
I = pi/4*(R^4-r^4);
% mesh
ele.num = 40;
ele.n = ele.num+1;
ele.mo = 10;
ele.l = L/ele.num;
ele.m = A*ele.l*rho;
x = linspace(0,L,ele.n);
%% assembly
[ele.Me,ele.Ke,ele.Me1,ele.Ke1] = getMatrices(ele.m,ele.l,I,E);
[row,~] = size(ele.Me);
M = zeros(ele.n*row/2);
K = zeros(ele.n*row/2);
M1 = zeros(ele.n*row/2/2);
K1 = zeros(ele.n*row/2/2);
for e = 1:ele.num
    indices = 1+(e-1)*row/2:row+(e-1)*row/2;
    indices1 = 1+(e-1)*row/2/2:row/2+(e-1)*row/2/2;
    M(indices,indices) = M(indices,indices) + ele.Me;
    K(indices,indices) = K(indices,indices) + ele.Ke;
    M1(indices1,indices1) = M1(indices1,indices1) + ele.Me1;
    K1(indices1,indices1) = K1(indices1,indices1) + ele.Ke1;
end
%% create matrix and get right columns and rows
% allesFest
% eineSeiteLose
% unterschiedlich1
unterschiedlich2
%
ind = getIndices(BCs);
% Berechnung der EV und EW
[Vx,Dx] = eigs(K(ind.x,ind.x),M(ind.x,ind.x),ele.mo,'sm');
[Vy,Dy] = eigs(K(ind.y,ind.y),M(ind.y,ind.y),ele.mo,'sm');
%% first own frequencies
% omegaSquare(1,:) = [500.55 , 504.67];
% omegaSquare(2,:) = [3803.1 , 3956.9];
% omegaSquare(3,:) = [14620  , 21405];
% omegaSquare(4,:) = [39944  , 84537];
% omegaSquare = omegaSquare*E*I/L^3/(ele.num*ele.m);
% omega = sqrt(omegaSquare)/(2*pi);
% for i = 1:4
%     fprintf('w_%1.0f = %07.3f ---- w_fe,%1.0f = %07.3f\n',i,omega(i,1),i,omega(i,2));
% end
%% plotten
figure()
    ax1 = subplot(1,2,1);
    hold on;
    title(ax1,'Eigenmoden x-Richtung')
    ax2 = subplot(1,2,2);
    hold on;
    title(ax2,'y-Richtung')
% create new temp vectors which incorporate the BC and also have the right
% size and just the x resp. y values
Vxx = zeros(ele.n,ele.mo); Vyy = zeros(ele.n,ele.mo);
if isnan(BCs(1))
    if isnan(BCs(end-3))
        Vxx(2:end-1,:) = Vx(1:2:end,:);
    else
        Vxx(2:end,:) = Vx(1:2:end,:);
    end
else
    if isnan(BCs(end-3))
        Vxx(1:end-1,:) = Vx(1:2:end,:);
    else
        Vxx(1:end,:) = Vx(1:2:end,:);
    end
end
if isnan(BCs(2))
    if isnan(BCs(end-2))
        Vyy(2:end-1,:) = Vy(1:2:end,:);
    else
        Vyy(2:end,:) = Vy(1:2:end,:);
    end
else
    if isnan(BCs(end-2))
        Vyy(1:end-1,:) = Vy(1:2:end,:);
    else
        Vyy(1:end,:) = Vy(1:2:end,:);
    end
end
% plotting
for m = ele.mo:-1:1
    plot(ax1,x,real(Vxx(:,m))/norm(Vxx(:,m)),...
        'DisplayName',sprintf('%1.2f Hz',(sqrt(Dx(m,m)))/(2*pi)))
    plot(ax2,x,real(Vyy(:,m))/norm(Vyy(:,m)),...
        'DisplayName',sprintf('%1.2f Hz',(sqrt(Dy(m,m)))/(2*pi)))
end

legend(ax1,'show')
legend(ax2,'show')