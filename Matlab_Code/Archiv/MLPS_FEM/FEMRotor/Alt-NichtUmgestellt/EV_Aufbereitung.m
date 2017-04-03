function EV2 = EV_Aufbereitung(EV1, M, Moden, Toleranz)

% Ziele:
% 1. Überprüfung: EV sollen konjugiert komplex sein
% 2. Klares Auftrennen der EV auf xz / yz-Ebene
% 3. Neusortieren
% 4. Massenormierung

Dim = size(EV1);

% Überprüfung konjugiert komplex
for n = 2:2:Dim(2)
    assert(max(abs(EV1(:,n))) < 1e-9, 'Eigenvektoren nicht konjugiert komplex')
end
EV = EV1(:,1:2:end);

% Auftrennung der Ebenen
for n = 1:Dim(1)
    if max(abs(EV(1:Dim(1)/2,n))) > 1e9*max(abs(EV(Dim(1)/2+1:end,n)))
        EV(Dim(1)/2+1:end,n) = 0;
    elseif max(abs(EV(Dim(1)/2+1:end,n))) > 1e9*max(abs(EV(1:Dim(1)/2,n)))
        EV(1:Dim(1)/2,n) = 0;
    end
end

%. 3. Neusortieren, reduzieren auf relevante Moden
EV2(1:Dim(1)/2,1:Dim(1)/2) = EV(1:Dim(1)/2, 1:2:end);
EV2(Dim(1)/2+1:Dim(1), Dim(1)/2+1:Dim(1)) = EV(Dim(1)/2+1:end, 2:2:end);

EV2(:,Dim(1)/2+Moden+1:end) = [];
EV2(:,Moden+1:Dim(1)/2) = [];


% 4. Massenormieren
Mmod = EV2.'*M*EV2;

for n=1:2*Moden
    EV2(:,n) = EV2(:,n)/sqrt(Mmod(n,n));
end

% 5. Ueberpruefen der Massenormierung

Fehler = max(max(EV2.'*M*EV2-eye(2*Moden,2*Moden)));
disp('Fehler bei Normierung der Massenmatrix')
disp(Fehler)
assert(Fehler < Toleranz, 'Massenormierung nicht erfolgreich');