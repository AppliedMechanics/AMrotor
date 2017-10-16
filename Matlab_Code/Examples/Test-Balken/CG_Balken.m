clear; home; close all;
%% init of parameters
% material
rho = 7446;
E = 211e9;
nu = 0.3;
G = 1/2/(1+nu)*E;
% geometry
R = 0.01;
r = 0;
A = pi*(R^2-r^2);
L = 0.6;
I = pi/4*(R^4-r^4);
% mesh
ele.num = 12;
ele.n = ele.num+1;
ele.mo = 7;
ele.l = L/ele.num;
ele.m = A*ele.l*rho;
x = linspace(0,L,ele.n);
%% assembly
[ele.Me,ele.Ke] = getMatrices(ele.m,ele.l,I,E,G,A,R);
[row,~] = size(ele.Me);
M = zeros((ele.num+1)*row/2);
K = zeros((ele.num+1)*row/2);
for e = 1:ele.num
    indices = 1+(e-1)*row/2:row+(e-1)*row/2;
    M(indices,indices) = M(indices,indices) + ele.Me;
    K(indices,indices) = K(indices,indices) + ele.Ke;
end
%% create matrix and get right columns and rows
% x richtung
K(1,1) = K(1,1)+1e17;
K(end-3,end-3) = K(end-3,end-3)+1e17;
% y Richtung
% K(2,2) = K(2,2)+1e17;
% K(end-2,end-2) = K(end-2,end-2)+1e17;

mat = (M\eye(size(M)))*K;

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
        'DisplayName',sprintf('%1.2f MHz',((Dx(m,m)))/(2*pi)/1000))
    plot(ax2,x,real(Vy(:,m))/norm(Vy(:,m)),...
        'DisplayName',sprintf('%1.2f MHz',((Dy(m,m)))/(2*pi)/1000))
end
legend(ax1,'show')
legend(ax2,'show')