function EV2 = EV_Aufbereitung2(EV1a, EV1b, M, Moden, Toleranz)

% Ziele:
% 1. Überprüfung: EV sollen konjugiert komplex sein
% 2. Neusortieren
% 3. Uebertrag der EV auf 2. Ebene (xz bzw. yz)
% 4. Massenormierung
% 5. Fehlerpruefung

Dim = size(EV1a);

% 1. Überprüfung konjugiert komplex
for n = 2:2:Dim(2)
    assert(max(abs(EV1a(:,n))) < 1e-9, 'Eigenvektoren nicht konjugiert komplex')
end
EVared = EV1a(:,1:2:end);

for n = 2:2:Dim(2)
    assert(max(abs(EV1b(:,n))) < 1e-9, 'Eigenvektoren nicht konjugiert komplex')
end
EVbred = EV1b(:,1:2:end);

%. 2. Neusortieren, reduzieren auf relevante Moden
EVared(:,Moden+1:end) = [];

EVbred(:,Moden+1:end) = [];

% 3. Aufstellen Gesamtmatrix
EV2 = [EVared, zeros(Dim(1),Moden); zeros(Dim(1),Moden), EVbred];


% 4. Massenormieren
Mmod = EV2.'*M*EV2;

for n=1:2*Moden
    EV2(:,n) = EV2(:,n)/sqrt(Mmod(n,n));
end

% 5. Ueberpruefen der Massenormierung

Fehler = max(max(EV2.'*M*EV2-eye(2*Moden,2*Moden)));
%disp('Fehler bei Normierung der Massenmatrix')
%disp(Fehler)
assert(Fehler < Toleranz, 'Massenormierung nicht erfolgreich');