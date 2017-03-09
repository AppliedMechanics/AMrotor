function [h] = Ergaenze_Inertialfeste_Streckenlast(h, px, py, pStart, pEnd, Knoten)

nKnoten = length(Knoten);
n=1;
while abs(pStart-Knoten(n)) > 1e-9 
    n = n+1;
    assert(n <= nKnoten, 'Start der Streckenlast muss auf Knoten liegen')
end
nStart = n;

while abs(pEnd-Knoten(n)) > 1e-9
    n = n+1;
    assert(n <= nKnoten, 'Ende der Streckenlast muss auf Knoten liegen');
end
nEnd = n;


for n = nStart+1 : nEnd
    l_Ele=Knoten(n)-Knoten(n-1);
    nPos1 = n*2;
    nPos2 = 2*length(Knoten) + n*2;
    
    % h = [B_V*px; B_W*py]
    h(nPos1-3) = h(nPos1-3) + px * l_Ele/2;
    h(nPos1-2) = h(nPos1-2) + px * l_Ele^2/12;
    h(nPos1-1) = h(nPos1-1) + px * l_Ele/2;
    h(nPos1)   = h(nPos1)   + px * (-l_Ele^2/12);
    
    h(nPos2-3) = h(nPos2-3) + py * l_Ele/2;
    h(nPos2-2) = h(nPos2-2) + py * (-l_Ele^2/12);
    h(nPos2-1) = h(nPos2-1) + py * l_Ele/2;
    h(nPos2)   = h(nPos2)   + py * l_Ele^2/12;
    
end