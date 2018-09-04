clear all 
clc

load Matrizen.mat

K_fest = K(7:300,7:300);
M_fest = M(7:300,7:300);

Kraft = 1;

f=sparse(294,1);
f(289)=Kraft;

u=K_fest\f;

u_x = u(1:6:end);

figure()
plot(u_x)

%% Eigenmoden
nModes=15;

 [V,D_tmp] = eigs(-K,M,nModes,'sm');
 [D,order] = sort(imag(sqrt(diag(D_tmp))));
    % sorting
    for i = 1:length(order)
        tmp = V(:,i);
        V(:,i) = V(:,order(i));
        V(:,order(i)) = tmp;
    end
    