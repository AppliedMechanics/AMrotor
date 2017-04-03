function [DD] = ErgaenzeDiskreteDaempfer(Knoten, Eingabematrix)

nKnoten = length(Knoten);

Dim = size(Eingabematrix);
DD=sparse(4*nKnoten, 4*nKnoten);

for n = 1:Dim(1)
    if (Eingabematrix(n,3) < 0 || Eingabematrix(n,3) > Knoten(end))
        disp('Diskreter Dämpfer: ')
        disp(n)
        error('Angriffspunkt außerhalb des Rotors');
    else
        if Eingabematrix(n,3) == Knoten(end)
            % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
            % zum letzten Element
            n0 = nKnoten-1;
            kappa = 1; %Kappa-Wert
            l_Ele = Knoten(end)-Knoten(end-1);
        else
            % Suche den linken Nachbarknoten
            % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
            n0=1;
            while Knoten(n0+1) <= Eingabematrix(n,3)
                n0 = n0+1;
            end
            l_Ele=Knoten(n0+1)-Knoten(n0);
            kappa = (Eingabematrix(n,3)-Knoten(n0)) / l_Ele;
        end
    end
    
    % Formfunktionen
    bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
    bv=[bw(1), -bw(2), bw(3), -bw(4)];
    
    z1 = n0*2-1;
    z2 = n0*2+2;
    z3 = 2*nKnoten+n0*2-1;
    z4 = 2*nKnoten+n0*2+2;
    

    % DD-Anteil
    DD(z1:z2,z1:z2) = DD(z1:z2,z1:z2) + Eingabematrix(n,1)*(bv.'*bv);
    DD(z3:z4,z3:z4) = DD(z3:z4,z3:z4) + Eingabematrix(n,2)*(bw.'*bw);  
   
end

