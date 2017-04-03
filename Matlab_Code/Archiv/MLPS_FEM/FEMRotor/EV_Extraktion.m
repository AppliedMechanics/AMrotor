function EV1 = EV_Extraktion(EV,Moden)

% Ziele
% 1. Abtrennen Weg-EV von Geschwindigkeits-EV
% 2. Reellifizieren
% 3. Normierung der Durchbiegung auf Wert 1

Dim = size(EV);

%Ueberpruefe, ob Weg- und Geschwindigkeits-EV gleiche Infos tragen (wird bis zum doppelten der gewaehlten Moden ueberprueft)
for n=1:4*Moden
    a = EV(end/2+1,n)/EV(1,n);
    assert(max(a*EV(2:end/2,n)-EV(end/2+2:end,n))<1e-3)
end

EV(1:end/2, :) = []; %loesche Weg-EV, Geschwindigkeits-EV ausreichend
EV1 = zeros(Dim(1)/2, Dim(1));
   
for n = 1:(Dim(1)/2)
   % Reellifizieren
   v1 = EV(:,2*n-1) + EV(:,2*n);
   v2 = 1i*(EV(:,2*n-1) - conj(EV(:,2*n)));
   
   % Normierung: Maximalwert der Biegung hat Betrag 1
   if max(abs(v1(1:2:end)))~=0
        v1 = v1/max(abs(v1(1:2:end)))*sign(max(abs(v1(1:2:end))));
   end
   if max(abs(v2(1:2:end)))~=0
        v2 = v2/max(abs(v2(1:2:end)))*sign(max(abs(v2(1:2:end))));
   end
   
   % Konvention: 1. Eintrag in Durchsenkungs-EV muss positiv sein
   if v1(1)<0
       v1=-v1;
   end
   if v2(1)<0
       v2=-v2;
   end
   
   %Speichern der Vektoren auf Ausgabematrix
   EV1(:,2*n-1) = v1;
   EV1(:,2*n) = v2;
end

