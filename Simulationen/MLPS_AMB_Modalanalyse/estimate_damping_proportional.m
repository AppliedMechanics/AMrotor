clear

% load('MDKr_symm.mat')
% K = r.rotor.matrices.K;
% M = r.rotor.matrices.M;

load('rotor_with_bearing_only.mat')
% eigentlich muss eingespanntes System betrachtet werden, da es im Exp. ja auch eingespannt ist
K = rotor_with_bearing_only.K;
M = rotor_with_bearing_only.M;

%% Geradin, Rixen 2015: Mechanical Vibrations Kap. 3.1.1
% stark abhaengig von den gewaehlten Werten
ftol = 1; % alles unter ftol ist eine Starrkoerpermode
epsilon_r(1) = 0.001;%0.01301; % Lehrsches Daempfungsmass der ersten Mode (die keine Starrkoerpermode ist)
% epsilon_r(2) = 0.005362; % Exp. 103.1Hz
epsilon_r(2) = 0.001;%0.005379; % Exp. 166.8Hz
% fprintf('vorher: norm(D) = %d\n',norm(r.rotor.matrices.D))
[EV,EW]=eig(K,M); %Loese volles EW-Problem
omega = real(sqrt(diag(EW))); %damit EW = +- i * omega_0r, da rein imaginaer

% sortiere EW, damit die ersten EW ungleich 0 gefudnen werden koennen
[~,i] = sort(abs(omega));
omegatmp = omega(i);
% EV = EV(:,i);
i = find(omegatmp>ftol*2*pi);
omegatmp = omegatmp(i);
ftmp = omegatmp/2/pi;
ftmp(1:12)

omega_0r = omegatmp([1,50]);%ausgewaehlte Moden mit f=[14.736,159.0289]Hz%omegatmp([1,3]);

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
% D=6.1090e-06*K+0.14707*M;
load('MDKr_symm.mat')
[EV,EW]=polyeig(K,D,M);
[~,i] = sort(abs(imag(EW)));
EW = EW(i);
EV = EV(:,i);
i = find(imag(EW)>0);
EW = EW(i);
EV = EV(:,i);
eigenfreq = imag(EW)/2/pi;
D_Lehr = -real(EW)./imag(EW);
figure
plot(eigenfreq,D_Lehr*100,'x')
xlabel('eigenfreq(Hz)')
ylabel('Lehr damping [percent]')
% ylim([0 100])
grid on

% save MDKr M D K r
