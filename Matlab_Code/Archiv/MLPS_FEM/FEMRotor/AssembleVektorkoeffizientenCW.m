function [w] = AssembleVektorkoeffizientenCW(par,Koeffizienten,Position)
%Koeffizienten [Fx My Fy Mx]
Knoten = par.Knoten;
nKnoten = length(Knoten);

Dim = length(Position);

w=zeros(4*nKnoten,1);

l=1;

for l = 1:Dim
Fx=Koeffizienten(l,1);
My=Koeffizienten(l,2);
Fy=Koeffizienten(l,3);
Mx=Koeffizienten(l,4);

F1_Position=Position(l);

n=2;
while F1_Position > Knoten(n)
    n = n+1;
end

% Kraft greift an den Knoten n-1 und n an
nPos1 = n*2; %revelante Koordinaten: nPos1-3 bis nPos1 in v-Richtung
nPos2 = 2*length(Knoten) + n*2; % relevante Koordinaten: nPos2-3 bis nPos2 in w-Richtung

l_Ele = Knoten(n) - Knoten(n-1);
xi = (F1_Position - Knoten(n-1)) / l_Ele; % xi von 0 bis 1

% h = [B_V * Fx; B_W * Fy] Kraft
w(nPos1-3) = w(nPos1-3) + Fx * (1-3*xi^2+2*xi^3);
w(nPos1-2) = w(nPos1-2) + Fx * l_Ele*xi*(xi-1)^2;
w(nPos1-1) = w(nPos1-1) + Fx * xi^2*(3-2*xi);
w(nPos1)   = w(nPos1)   + Fx * l_Ele*xi^2*(xi-1);

w(nPos2-3) = w(nPos2-3) + Fy * (1-3*xi^2+2*xi^3);
w(nPos2-2) = w(nPos2-2) + Fy * (-l_Ele)*xi*(xi-1)^2;
w(nPos2-1) = w(nPos2-1) + Fy * xi^2*(3-2*xi);
w(nPos2)   = w(nPos2)   + Fy * (-l_Ele)*xi^2*(xi-1);

% h = [B_V' * My; -B_W' * Mx] Moment
w(nPos1-3) = w(nPos1-3) + My * (-6*xi+6*xi^2)/l_Ele;
w(nPos1-2) = w(nPos1-2) + My * (3*xi^2-4*xi+1);
w(nPos1-1) = w(nPos1-1) + My * (6*xi-6*xi^2)/l_Ele;
w(nPos1)   = w(nPos1)   + My * (3*xi^2-2*xi);

w(nPos2-3) = w(nPos2-3) - Mx * (-6*xi+6*xi^2)/l_Ele;
w(nPos2-2) = w(nPos2-2) - Mx * (-3*xi^2+4*xi-1);
w(nPos2-1) = w(nPos2-1) - Mx * (6*xi-6*xi^2)/l_Ele;
w(nPos2)   = w(nPos2)   - Mx * (-3*xi^2+2*xi);

end