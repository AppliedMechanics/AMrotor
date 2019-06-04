%% Geradin, Rixen 2015: Mechanical Vibrations Kap. 3.1.3
% proportinal damping for unknown mode-damping
% spectral expansion for known mode-damping
%
% Ziel:
% beta_rr = 2*epsilon_r*omega_0r*mu_r,  fuer r<=m
% beta_rr = a*omega_0r^2*mu_r,          fuer r> m
% 
% beta_rr: Eintraege der Diagonalen-Modalen Daempfungsmatrix
% epsilon_r: Lehrsches Daempfungsmass
% omega_r0: ungedaempfte Eigenfrequenz Nummer r
% mue_r: modale Masse
% a: Steigung der modalen Daempfung
clear

%% Eingabe der Daten aus der Messung
% free-free-Messung vom 29.03.2019 mit LMS-System und AMimpact 2
Experiment.f = [22.6470261719311,106.131311936756,175.617964736083,215.302199549077]; %Eigenfrequenzen aus dem Experiment
Experiment.D = [0.00254850010437037,0.00144873146290767,0.00430302424400921,0.00231240233924187]; %Lehrsche Daempfungsmasze aus dem Experiment
figure
plot(Experiment.f,Experiment.D,'bx')
xlabel('Eigenfrequenz [Hz]')
ylabel('Daempfung [%]')
title('Experimentell ermittelt')


%% Lade die Daten
% load('rotor_with_bearing_only.mat')
load('rotor_free_free.mat')
% K = r.rotor.matrices.K;
% M = r.rotor.matrices.M;
% % eigentlich muss eingespanntes System betrachtet werden, da es im Exp. ja auch eingespannt ist
% K = rotor_with_bearing_only.K;
% M = rotor_with_bearing_only.M;

[EV,EW]=eig(K,M); %Loese volles EW-Problem, X ist bereits mass normalized
omega = real(sqrt(diag(EW))); 
[~,i] = sort(abs(omega));
omega_0 = omega(i);
X = EV(:,i);
% % baue Paare von EW, wg. sqrt
% for k = 2:length(omega_0)
%     omegatmp(2*k-1:2*k) = [omega_0(k), omega_0(k)];
%     Xtmp(:,2*k-1:2*k) = [X(:,k), X(:,k)];
% end
% X=Xtmp;
% omega_0 = omegatmp;

f_0 = omega_0/2/pi;
mu = diag(X.'*M*X);

% waehle a, z.B. sodass die Mode mit der hoechsten Eigenfreq die Lehrsche Daempfung 1 hat
a = 5e-7;%1e-7;

% proportional damping
C_p = a*K;

% setze die bekannten Daempfungen
% VORGEHEN: Betrachte zunaechts f_0 und vergliche mit f aus Experiment,
% ordne dann passende Daempfungen zu
%Zuordnung von Simulationsmoden zu Experimentmoden
iSim = [7,8;11,12;13,14;15,16]; % Biegemoden; Moden 9,10 wahrscheinlich Torsion bzw. Axialmoden (dazu liegen mir keine Daempfungswerte vor)
epsilon = NaN(1,16);
epsilon(1:6) = 0; % Starrkoerpermoden ohne Daempfung
for i = 1:size(iSim,1)
    epsilon(iSim(i,:)) = Experiment.D(i);
end



% spectral expansion
C_se = zeros(size(K));
for s = find(~isnan(epsilon))
    C_se = C_se + K*X(:,s) * (2*epsilon(s)/(omega_0(s)^3*mu(s)) - a/(omega_0(s)^2*mu(s))) * X(:,s).'*K;
end


% gesamte Daempfungsmatrix
C = C_p + C_se;

%% Teste System mit Daempfung:
[EV,EW]=polyeig(K,C,M);
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
xlabel('eigenfrequency')
ylabel('Lehr damping [percent]')
% ylim([0 100])
grid on

save D_damping_modal_expansion C % wenn Ergebnis zufriedenstellend -> abspeichern