function [x,y,dx,dy] = BerechneOrbit(Position, Knoten, ModaleBiegung, EV2, Moden)

nKnoten = length(Knoten);

if (Position < 0 || Position > Knoten(end))
    error('Orbit ausserhalb Rotor');
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
    end
end

bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
bv=[bw(1), -bw(2), bw(3), -bw(4)];

% Auswertung Biegung v
z1 = n0*2-1;
z2 = n0*2+2;
EV2Auswahl = EV2(z1:z2,:);
x = bv*EV2Auswahl*ModaleBiegung(1:2*Moden,:); % Deformation
dx = bv*EV2Auswahl*ModaleBiegung(2*Moden+1:end,:); %Absolutgeschwindigkeit
% Auswertung Biegung w
z1 = 2*length(Knoten)+n0*2-1;
z2 = 2*length(Knoten)+n0*2+2;
EV2Auswahl = EV2(z1:z2,:);
y = bw*EV2Auswahl*ModaleBiegung(1:2*Moden,:);
dy = bw*EV2Auswahl*ModaleBiegung(2*Moden+1:end,:);



