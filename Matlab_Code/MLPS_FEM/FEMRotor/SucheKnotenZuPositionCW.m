function [P] = SucheKnotenZuPositionCW(par,Position)

Knoten = par.Knoten;

n=2;
while Position > Knoten(n)
    n = n+1;
end

% Kraft greift an den Knoten n-1 und n an
nPos1 = n*2; %revelante Koordinaten: nPos1-3 bis nPos1 in v-Richtung
nPos2 = 2*length(Knoten) + n*2; % relevante Koordinaten: nPos2-3 bis nPos2 in w-Richtung


P=[nPos1-1 nPos1 nPos2-1 nPos2];
end