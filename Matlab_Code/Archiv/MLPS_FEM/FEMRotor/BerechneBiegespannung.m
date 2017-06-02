function Sigma = BerechneBiegespannung(Knoten, E, Geometrie2, EV2, Moden, ModaleBiegung)

Sigma = 0*Knoten;

% Ueber Balken: jeweils Auswertung am linken Knoten
for n = 1:length(Knoten)-1
    l_Ele = Knoten(n+1)-Knoten(n);   
    kappaX = 1/l_Ele^2*[-6, -4*l_Ele, 6, -2*l_Ele]*EV2(n*2-1:n*2+2,:)*ModaleBiegung(1:2*Moden); %ACHTUNG: Vorzeichen hier unsicher, für diese Anwendung jedoch egal
    kappaY = -1/l_Ele^2*[-6, 4*l_Ele, 6, 2*l_Ele]*EV2(2*length(Knoten)+2*n-1:2*length(Knoten)+2*n+2,:)*ModaleBiegung(1:2*Moden);
    n1 = find(Geometrie2(:,1)<=Knoten(n), 1, 'last');       
    Sigma(n) = E*Geometrie2(n1,2)*(kappaX^2+kappaY^2)^0.5;
end

% Am letzten Punkt bleibt Moment 0 -> macht so Sinn, da Balken aus