function [A] = AssembleMatrixkoeffizientenCW(par,Koeffizienten,Position)
%Koeffizientenvektor in Form: m11 m12 m21 m22, Position in Meter
Knoten = par.Knoten;
nKnoten = length(Knoten);


Dim = length(Position);
A=sparse(4*nKnoten, 4*nKnoten);

for n = 1:Dim
    if (Position(n) < 0 || Position(n) > Knoten(end))
        disp('Diskreter D√§mpfer: ')
        disp(n)
        error('Angriffspunkt au√üerhalb des Rotors');
    else
        if Position(n) == Knoten(end)
            % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
            % zum letzten Element
            n0 = nKnoten-1;
            kappa = 1; %Kappa-Wert
            l_Ele = Knoten(end)-Knoten(end-1);
        else
            % Suche den linken Nachbarknoten
            % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
            n0=1;
            while Knoten(n0+1) <= Position(n)
                n0 = n0+1;
            end
            l_Ele=Knoten(n0+1)-Knoten(n0);
            kappa = (Position(n)-Knoten(n0)) / l_Ele;
        end
    end
    
    % Formfunktionen
    bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = 2*nKnoten+n0*2-1;
    z4 = 2*nKnoten+n0*2+2;
    

    % Diag-Anteil
    A(z1:z2,z1:z2) = A(z1:z2,z1:z2) + Koeffizienten(n,1)*(bv.'*bv);
    A(z3:z4,z3:z4) = A(z3:z4,z3:z4) + Koeffizienten(n,4)*(bw.'*bw);  
    
    % Nebendiagonal-Anteil, Verbessern und ¸berpr¸fen
    A(z1:z2,z3:z4) = A(z1:z2,z3:z4) + Koeffizienten(n,2)*(bv.'*bw);
    A(z3:z4,z1:z2) = A(z3:z4,z1:z2) + Koeffizienten(n,3)*(bw.'*bv);
    
end

