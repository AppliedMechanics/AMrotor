function [h] = Ergaenze_Inertialfeste_KraftCW(h,par,Parameter)

Knoten = par.Knoten;
Fx=Parameter(1);
Fy=Parameter(2);
F1_Position=Parameter(3);


n=2;
while F1_Position > Knoten(n)
    n = n+1;
end

% Kraft greift an den Knoten n-1 und n an
nPos1 = n*2; %revelante Koordinaten: nPos1-3 bis nPos1 in v-Richtung
nPos2 = 2*length(Knoten) + n*2; % relevante Koordinaten: nPos2-3 bis nPos2 in w-Richtung

l_Ele = Knoten(n) - Knoten(n-1);
xi = (F1_Position - Knoten(n-1)) / l_Ele; % xi von 0 bis 1

% h = [B_V * Fx; B_W * Fy]
h.h(nPos1-3) = h.h(nPos1-3) + Fx * (1-3*xi^2+2*xi^3);
h.h(nPos1-2) = h.h(nPos1-2) + Fx * l_Ele*xi*(xi-1)^2;
h.h(nPos1-1) = h.h(nPos1-1) + Fx * xi^2*(3-2*xi);
h.h(nPos1)   = h.h(nPos1)   + Fx * l_Ele*xi^2*(xi-1);

h.h(nPos2-3) = h.h(nPos2-3) + Fy * (1-3*xi^2+2*xi^3);
h.h(nPos2-2) = h.h(nPos2-2) + Fy * (-l_Ele)*xi*(xi-1)^2;
h.h(nPos2-1) = h.h(nPos2-1) + Fy * xi^2*(3-2*xi);
h.h(nPos2)   = h.h(nPos2)   + Fy * (-l_Ele)*xi^2*(xi-1);

   

end