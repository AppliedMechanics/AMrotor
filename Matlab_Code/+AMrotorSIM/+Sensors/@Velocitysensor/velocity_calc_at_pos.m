function [x_pos,beta_pos,y_pos,alpha_pos] = velocity_calc_at_pos(Position,rotorsystem)

Z=rotorsystem.time_result.dX;
rotorpar = rotorsystem.rotor.cnfg;
moment_of_inertia = rotorsystem.rotor.moment_of_inertia;
nodes = rotorsystem.rotor.nodes;

n_nodes = length(nodes);
sd=rotorpar.shear_def;
  if (Position < 0 || Position > nodes(end))
    error('Orbit ausserhalb Rotor');
  else
    if Position == nodes(end)
        % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
        % zum letzten Element
        n0 = n_nodes-1;
        kappa = 1; %Kappa-Wert
        l_Ele = nodes(end)-nodes(end-1);
        PhiS = sd*moment_of_inertia(end-1,5)/l_Ele^2;
        
    else
        % Suche den linken Nachbarknoten
        % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
        n0=1;
        b=1;
        while nodes(n0+1) <= Position
            n0 = n0+1;
        end
        l_Ele=nodes(n0+1)-nodes(n0);
        kappa = (Position-nodes(n0)) / l_Ele;
        
        while rotorpar.rotor_dimensions(b,1) <= Position
            b=b+1;
            
        end
        PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;
    end
  end
  

%Formfunktionen

bw =(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3,-l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)),3*kappa^2-2*kappa^3+kappa*PhiS,-l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
bv =[bw(1), -bw(2), bw(3), -bw(4)];
    

% bw=[1-3*kappa^2+2*kappa^3, l_Ele*(-kappa^3+2*kappa^2-kappa), 3*kappa^2-2*kappa^3, l_Ele*(-kappa^3+kappa^2)];
% bv=[bw(1), -bw(2), bw(3), -bw(4)];

% Auswertung Biegung v
z1 = n0*2-1;
z2 = n0*2+2;
z3 = 2*n_nodes+n0*2-1;
z4 = 2*n_nodes+n0*2+2;

x_pos = bv*Z(z1:z2,:);
y_pos = bw*Z(z3:z4,:);

% h = [B_V' * My; -B_W' * Mx] Moment

cw=(1/(1+PhiS))*[(-PhiS-6*kappa+6*kappa^2)/l_Ele, -(3*kappa^2-4*kappa+0.5*PhiS*(1-2*kappa)+1), (6*kappa-6*kappa^2+PhiS)/l_Ele, -(3*kappa^2-2*kappa-0.5*PhiS*(1-2*kappa))];
cv=[-cw(1), cw(2), -cw(3), cw(4)];


% cw=[(-6*kappa+6*kappa^2)/l_Ele ,  (3*kappa^2-4*kappa+1)    , (6*kappa-6*kappa^2)/l_Ele ,(3*kappa^2-2*kappa)];
% cv=[-(-6*kappa+6*kappa^2)/l_Ele, -(-3*kappa^2+4*kappa-1)   ,-(6*kappa-6*kappa^2)/l_Ele ,-(-3*kappa^2+2*kappa)];
%              -cw(1)                       cw(2)                     -cw(3)                   cw(4)


alpha_pos =cv*Z(z1:z2,:);
beta_pos = cw*Z(z3:z4,:);
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

