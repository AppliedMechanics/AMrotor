%% Geradin, Rixen 2015: Mechanical Vibrations kap. 3.1.3
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

%% Lade die Daten
load('rotor_with_bearing_only.mat')
% K = r.rotor.matrices.K;
% M = r.rotor.matrices.M;
% eigentlich muss eingespanntes System betrachtet werden, da es im Exp. ja auch eingespannt ist
K = rotor_with_bearing_only.K;
M = rotor_with_bearing_only.M;

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
a = 1e-7;

% proportional damping
C_p = a*K;

% setze die bekannten Daempfungen
% VORGEHEN: Betrachte zunaechts f_0 und vergliche mit f aus Experiment,
% ordne dann passende Daempfungen zu
epsilon = NaN(1,13);
% epsilon(1) = 0.01301; % 14.6 Hz in Sim %16.7 Hz in Exp %TORSION
epsilon(2:3) = 0.01301; % 14.7 Hz in Sim %16.7 Hz in Exp
% epsilon(4) = 0.02548;%41.3 Hz in Sim, 52.6Hz in Exp %TORSION
% epsilon(5:6) = 0.02548;%58.1 Hz in Sim, 52.6Hz in Exp %KEIN SICHERER WERT
% epsilon(7:8) = 0.02548;%58.8 Hz in Sim, 52.6Hz in Exp %KEIN SICHERER WERT
% epsilon(9) = 0.02548;%64.4 Hz in Sim, 52.6Hz in Exp %KEIN SICHERER WERT %TORSION
epsilon(10:11) = 0.005362; % 102.5 Hz in Sim %103.1 Hz in Exp
epsilon(12:13) = 0.005379; % 159.0 Hz in Sim %166.8 Hz in Exp


% spectral expansion
C_se = zeros(size(K));
for s = find(~isnan(epsilon))
    C_se = C_se + K*X(:,s) * (2*epsilon(s)/(omega_0(s)^3*mu(s)) - a/(omega_0(s)^2*mu(s))) * X(:,s).'*K;
end


% gesamte Daempfugnsmatrix
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

% save D_damping_modal_expansion C % wenn Ergebnis zufriedenstellend -> abspeichern