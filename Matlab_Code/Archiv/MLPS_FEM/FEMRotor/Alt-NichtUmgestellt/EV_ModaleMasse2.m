function EV_ModaleMasse2(EV1, M, Moden)

% Ziele:
% 1. Überprüfung: EV sollen konjugiert komplex sein
% 2. Klares Auftrennen der EV auf xz / yz-Ebene
% 3. Neusortieren
% 4. Modale Masse des 1. Modes

Dim = size(EV1);

% 1. Überprüfung konjugiert komplex
for n = 2:2:Dim(2)
    assert(max(abs(EV1(:,n))) < 1e-9, 'Eigenvektoren nicht konjugiert komplex')
end
EV = EV1(:,1:2:end);

%. 2. Neusortieren, reduzieren auf relevante Moden
EV(:,Moden+1:end) = [];

% 3. Uebertrag der EV auf 2. Ebene
EV2 = [EV, zeros(Dim(1),Moden); zeros(Dim(1),Moden), EV];

for n = Dim(1)+2:2:2*Dim(1)
    EV2(n,:) = -EV2(n,:);
end

% 4. Modale Masse des 1. Modes
% Anmerkung: EV1 so normiert, dass maximaler Biegungseintrag des Modes=1
% ist. Gibt so sinnvolle Wichtung der Massen (analog zu Ritzansatz:
% Vollausschlag hat Amplitude 1)

M_m=EV2.'*M*EV2;
disp(M_m(1,1))


