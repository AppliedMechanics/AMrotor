function [h] = Ergaenze_UnwuchtKraftCW(h, par, Parameter)

% Parameter in Form Position, Unwuchtkraft, psi [in rad]

nKnoten = length(par.Knoten);
Dim = size(Parameter);

for n = 1:Dim(1)
    if (Parameter(n,1) < 0 || Parameter(n,1) > par.Knoten(end))
        disp('Unwuchtmasse: ')
        disp(n)
        error('Angriffspunkt außerhalb des Rotors');
    else
        if Parameter(n,1) == par.Knoten(end)
            % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
            % zum letzten Element
            n0 = nKnoten-1;
            kappa = 1; %Kappa-Wert
            l_Ele = par.Knoten(end)-par.Knoten(end-1);
        else
            % Suche den linken Nachbarknoten
            % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
            n0=1;
            while par.Knoten(n0+1) <= Parameter(n,1)
                n0 = n0+1;
            end
            l_Ele=par.Knoten(n0+1)-par.Knoten(n0);
            kappa = (Parameter(n,1)-par.Knoten(n0)) / l_Ele;
        end
    end
    
    % Formfunktionen
    bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    % Positionen in Gesamtvektor
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = nKnoten*2+n0*2-1;
    z4 = nKnoten*2+n0*2+2;
    
    h.h_cos(z1:z2) = h.h_cos(z1:z2) + bv.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_cos(z3:z4) = h.h_cos(z3:z4) + bw.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_sin(z1:z2) = h.h_sin(z1:z2) - bv.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_sin(z3:z4) = h.h_sin(z3:z4) + bw.'*Parameter(n,2)*cos(Parameter(n,3));
    
    h.h_cos(z1:z2) = h.h_cos(z1:z2) + bv.'*Parameter(n,2)*sin(Parameter(n,3));
    h.h_cos(z3:z4) = h.h_cos(z3:z4) - bw.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_sin(z1:z2) = h.h_sin(z1:z2) + bv.'*Parameter(n,2)*cos(Parameter(n,3));
    h.h_sin(z3:z4) = h.h_sin(z3:z4) + bw.'*Parameter(n,2)*sin(Parameter(n,3));
end