function [x,beta,y,alpha] = ExtrahiereZustandsvektorCW(Position,par,Z)

Knoten = par.Knoten;
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
z3 = 2*nKnoten+n0*2-1;
z4 = 2*nKnoten+n0*2+2;

x = bv*Z(z1:z2,:);
y = bw*Z(z3:z4,:);

% h = [B_V' * My; -B_W' * Mx] Moment
cw=[(-6*kappa+6*kappa^2)/l_Ele,(3*kappa^2-4*kappa+1), (6*kappa-6*kappa^2)/l_Ele,(3*kappa^2-2*kappa)];
cv=[-(-6*kappa+6*kappa^2)/l_Ele, -(-3*kappa^2+4*kappa-1),-(6*kappa-6*kappa^2)/l_Ele,-(-3*kappa^2+2*kappa)];

alpha =cv*Z(z1:z2,:);
beta = cw*Z(z3:z4,:);
end
% 
% % h = [B_V * Fx; B_W * Fy] Kraft
% w(nPos1-3) = w(nPos1-3) + Fx * (1-3*xi^2+2*xi^3);
% w(nPos1-2) = w(nPos1-2) + Fx * l_Ele*xi*(xi-1)^2;
% w(nPos1-1) = w(nPos1-1) + Fx * xi^2*(3-2*xi);
% w(nPos1)   = w(nPos1)   + Fx * l_Ele*xi^2*(xi-1);
% 
% w(nPos2-3) = w(nPos2-3) + Fy * (1-3*xi^2+2*xi^3);
% w(nPos2-2) = w(nPos2-2) + Fy * (-l_Ele)*xi*(xi-1)^2;
% w(nPos2-1) = w(nPos2-1) + Fy * xi^2*(3-2*xi);
% w(nPos2)   = w(nPos2)   + Fy * (-l_Ele)*xi^2*(xi-1);
% 
% % h = [B_V' * My; -B_W' * Mx] Moment
% w(nPos1-3) = w(nPos1-3) + My * (-6*xi+6*xi^2)/l_Ele;
% w(nPos1-2) = w(nPos1-2) + My * (3*xi^2-4*xi+1);
% w(nPos1-1) = w(nPos1-1) + My * (6*xi-6*xi^2)/l_Ele;
% w(nPos1)   = w(nPos1)   + My * (3*xi^2-2*xi);
% 
% w(nPos2-3) = w(nPos2-3) - Mx * (-6*xi+6*xi^2)/l_Ele;
% w(nPos2-2) = w(nPos2-2) - Mx * (-3*xi^2+4*xi-1);
% w(nPos2-1) = w(nPos2-1) - Mx * (6*xi-6*xi^2)/l_Ele;
% w(nPos2)   = w(nPos2)   - Mx * (-3*xi^2+2*xi);

