load('r.mat')
K = r.rotor.matrices.K;
M = r.rotor.matrices.M;


% %% Schaetze Daempfungsmatrix
% fprintf('vorher: norm(D) = %d\n',norm(r.rotor.matrices.D))
% [U,~]=eig(r.rotor.matrices.K,r.rotor.matrices.M); %Loese volles EW-Problem
% d_m = 0.01;% 1 Prozent modale Daempfung
% % Dm = zeros(size(U,1));
% % Dm(1,1) = d_m;
% Nm = size(U,1);
% dmmax = 0.05;
% dmmin = 0.005;
% dm = (dmmax-dmmin)/(Nm-1)*(1:Nm)+dmmin-(dmmax-dmmin)/(Nm-1);
% Dm = diag(dm);
% 
% D = U'*Dm*U;
% % temp = [r.rotor.matrices.K,r.rotor.matrices.M] \ D;
% % alp1 = temp(1:end/2,:);
% % alp2 = temp(end/2+1:end,:);
% % alp1 = diag(alp1);
% % alp2 = diag(alp2);
% % alp1 = mean(alp1);
% % alp2 = mean(alp2);
% r.rotor.matrices.D = D;
% fprintf('nachher: norm(D) = %d\n',norm(D))
% 
% save MDK M D K
% 
% % alp = fsolve(@myfun,[0,0]);
% alp = lsqnonlin(@myfun,[0,0]);
% 
% alpha1 = alp(1)
% alpha2 = alp(2)
% 
% D = alpha1*K + alpha2*M;
% [EV,EW]=polyeig(K,D,M);
% [~,i] = sort(abs(imag(EW)))
% EW = EW(i);
% EV = EV(:,i);
% i = find(imag(EW)>0);
% EW = EW(i);
% EV = EV(:,i);
% D_Lehr = -real(EW)./imag(EW)
% 
% function residuum = myfun(alp)
% load('MDK.mat')
% residuum = D-alp(1)*K-alp(2)*M;
% end

%% Geradin, Rixen 2015: Mechanical Vibrations kap. 3.1.1
ftol = 1; % alles unter ftol ist eine Starrkoerpermode
epsilon_r(1) = 0.01; % Lehrsches Daempfungsmass der ersten Mode (die keine Starrkoerpermode ist)
epsilon_r(2) = 0.01;
fprintf('vorher: norm(D) = %d\n',norm(r.rotor.matrices.D))
[EV,EW]=eig(r.rotor.matrices.K,r.rotor.matrices.M); %Loese volles EW-Problem
omega = real(sqrt(diag(EW))); %damit EW = +- i * omega_0r, da rein imaginaer

% sortiere EW, damit die ersten EW ungleich 0 gefudnen werden koennen
[~,i] = sort(abs(omega));
omegatmp = omega(i);
% EV = EV(:,i);
i = find(omegatmp>ftol*2*pi);
omegatmp = omegatmp(i);
ftmp = omegatmp/2/pi;
ftmp(1:10)

omega_0r = omegatmp([1,3]);%omegatmp([1,3]);

% vgl. example 3.1
b(1,1) = 2*epsilon_r(1) * omega_0r(1);
b(2,1) = 2*epsilon_r(2) * omega_0r(2);
A(1,1) = omega_0r(1)^2;
A(2,1) = omega_0r(2)^2;
A(1:2,2) = [1;1];

alpha = A\b;
alpha1 = alpha(1)
alpha2 = alpha(2)

%% Teste System mit Daempfung:
D = alpha1*K + alpha2*M;
[EV,EW]=polyeig(K,D,M);
[~,i] = sort(abs(imag(EW)));
EW = EW(i);
EV = EV(:,i);
i = find(imag(EW)>0);
EW = EW(i);
EV = EV(:,i);
D_Lehr = -real(EW)./imag(EW);
figure
plot(D_Lehr*100,'x')
xlabel('mode number')
ylabel('Lehr damping [percent]')
ylim([0 100])
grid on

