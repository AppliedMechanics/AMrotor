function [KF] = ErgaenzeKupplung(Knoten, k_Schub, k_Biegung, Position)

nKnoten = length(Knoten);
KF = zeros(4*nKnoten,4*nKnoten);

if (Position < Knoten(1) || Position > Knoten(end))
    error('Kupplung: Angriffspunkt außerhalb des Rotors');
else
    if Position == Knoten(end)
        % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
        % zum letzten Element
        n0 = nKnoten-1;
        kappa = 1; %Kappa-Wert
        l_Ele = Knoten(end)-Knoten(end-1);
    else
        % Suche den linken Nachbarknoten
        % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
        n0=1;
        while Knoten(n0+1) <= Position
            n0 = n0+1;
        end
        l_Ele=Knoten(n0+1)-Knoten(n0);
        kappa = (Position-Knoten(n0)) / l_Ele;
%         if (kappa ~=0 && kappa ~= 1)
%             disp('Warnung: Kupplung sitzt nicht an Knoten. Nicht verifiziert')
%         end
    end
end

% Formfunktionen
bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
bv=[bw(1), -bw(2), bw(3), -bw(4)];
bwAbl = [(-6*kappa+6*kappa^2)/l_Ele, -3*kappa^2+4*kappa-1, (6*kappa-6*kappa^2)/l_Ele, (-3*kappa^2+2*kappa)];
bvAbl = [bwAbl(1), -bwAbl(2), bwAbl(3), -bwAbl(4)];

% Positionen in Gesamtmatrix
z1 = n0*2-1;
z2 = n0*2+2;
z3 = nKnoten*2+n0*2-1;
z4 = nKnoten*2+n0*2+2;

KF(z1:z2,z1:z2) = KF(z1:z2,z1:z2)+k_Schub*(bv.'*bv);
KF(z3:z4,z3:z4) = KF(z3:z4,z3:z4)+k_Schub*(bw.'*bw);
KF(z1:z2,z1:z2) = KF(z1:z2,z1:z2)+k_Biegung*(bvAbl.'*bvAbl);
KF(z3:z4,z3:z4) = KF(z3:z4,z3:z4)+k_Biegung*(bwAbl.'*bwAbl);