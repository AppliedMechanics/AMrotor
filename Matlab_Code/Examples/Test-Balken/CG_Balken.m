clear; home; close all;
%% init of parameters
% material
rho = 7446;
E = 211e9;
nu = 0.3;
G = 1/2/(1+nu)*E;
% geometry
R = 0.005;
r = 0;
A = pi*(R^2-r^2);
L = 1;
I = pi/4*(R^4-r^4);
% mesh
ele.num = 30;
ele.n = ele.num+1;
ele.mo = 4;
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
tmp = 1:length(M);
tmp1 = 1:length(M1);
% x richtung
tmp(1) = NaN; tmp(3) = NaN;
tmp(end-3) = NaN; tmp(end-1) = NaN;
tmp1(1) = NaN; tmp1(2) = NaN;
% y Richtung
tmp(2) = NaN; tmp(4) = NaN;
tmp(end-2) = NaN; tmp(end) = NaN;
tmp1(end-1) = NaN; tmp1(end) = NaN;
ind = tmp(~isnan(tmp));
ind1=tmp1(~isnan(tmp1));

mat = (M\eye(size(M)))*K;
mat1 = (M1\eye(size(M1)))*K1;
[V,D] = eigs(K(ind,ind),M(ind,ind),4,'sm');
real(sqrt(diag(D))/2/pi)
[V1,D1] = eigs(K1(ind1,ind1),M1(ind1,ind1),4,'sm');
real(sqrt(diag(D1))/2/pi)

if row == 12
    start.x = 2; start.y = 3;    
elseif row == 8
    start.x = 1; start.y = 2;    
end

% [V.in,D.in] = eigs(mat,ele.mo,'sm');
% D.in = sqrt(D.in);
% 
% [D.sorted,D.sortOrder] = sort(diag(D.in));
% 
% for i = 1:numel(D.sortOrder)
%     V.out(:,i) = V.in(:,D.sortOrder(i));
%     D.out(i,i) = D.sorted(D.sortOrder(i),1);
% end
% 
% Vx = V.out(start.x:row/2:end,:);
% Dx = D.out;
% 
% Vy = V.out(start.y:row/2:end,:);
% Dy = D.out;

index.x = start.x:row/2:row/2*ele.n;
index.y = start.y:row/2:row/2*ele.n;

% i = index.x;
% [Vx,Dx] = eigs((M(i,i)\eye(size(M(i,i))))*K(i,i),ele.mo,'sm');
% i = index.y;
% [Vy,Dy] = eigs((M(i,i)\eye(size(M(i,i))))*K(i,i),ele.mo,'sm'); 

i = index.x;
[Vx,Dx] = eigs(mat(i,i),ele.mo,'sm');
i = index.y;
[Vy,Dy] = eigs(mat(i,i),ele.mo,'sm'); 

Dx = sqrt(Dx);
Dy = sqrt(Dy);
%% first own frequencies
omegaSquare(1,:) = [500.55 , 504.67];
omegaSquare(2,:) = [3803.1 , 3956.9];
omegaSquare(3,:) = [14620  , 21405];
omegaSquare(4,:) = [39944  , 84537];
omegaSquare = omegaSquare*E*I/L^3/(ele.num*ele.m);
omega = sqrt(omegaSquare)/(2*pi);
for i = 1:4
    fprintf('w_%1.0f = %07.3f ---- w_fe,%1.0f = %07.3f\n',i,omega(i,1),i,omega(i,2));
end
%% plotten
figure()
    ax1 = subplot(1,2,1);
    hold on;
    title(ax1,'Eigenmoden x-Richtung')
    ax2 = subplot(1,2,2);
    hold on;
    title(ax2,'y-Richtung')
   
for m = 1:ele.mo
    plot(ax1,x,real(Vx(:,m))/norm(Vx(:,m)),...
        'DisplayName',sprintf('%1.2f kHz',((Dx(m,m)))/(2*pi)/1000))
    plot(ax2,x,real(Vy(:,m))/norm(Vy(:,m)),...
        'DisplayName',sprintf('%1.2f kHz',((Dy(m,m)))/(2*pi)/1000))
end

legend(ax1,'show')
legend(ax2,'show')

