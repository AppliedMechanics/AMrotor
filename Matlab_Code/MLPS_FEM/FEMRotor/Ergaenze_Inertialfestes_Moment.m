function [h] = Ergaenze_Inertialfestes_Moment(h, Mx, My, F1_Position, Knoten)

n=2;
while F1_Position > Knoten(n)
    n = n+1;
end

% Kraft greift an den Knoten n-1 und n an
nPos1 = n*2; %revelante Koordinaten: nPos1-3 bis nPos1 in v-Richtung
nPos2 = 2*length(Knoten) + n*2; % relevante Koordinaten: nPos2-3 bis nPos2 in w-Richtung

l_Ele = Knoten(n) - Knoten(n-1);
xi = (F1_Position - Knoten(n-1)) / l_Ele; % xi von 0 bis 1

% h = [B_V' * My; -B_W' * Mx]
h(nPos1-3) = h(nPos1-3) + My * (-6*xi+6*xi^2)/l_Ele;
h(nPos1-2) = h(nPos1-2) + My * (3*xi^2-4*xi+1);
h(nPos1-1) = h(nPos1-1) + My * (6*xi-6*xi^2)/l_Ele;
h(nPos1)   = h(nPos1)   + My * (3*xi^2-2*xi);

h(nPos2-3) = h(nPos2-3) - Mx * (-6*xi+6*xi^2)/l_Ele;
h(nPos2-2) = h(nPos2-2) - Mx * (-3*xi^2+4*xi-1);
h(nPos2-1) = h(nPos2-1) - Mx * (6*xi-6*xi^2)/l_Ele;
h(nPos2)   = h(nPos2)   - Mx * (-3*xi^2+2*xi);

end