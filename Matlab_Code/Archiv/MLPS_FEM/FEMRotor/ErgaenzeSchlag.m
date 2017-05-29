function [h_sin, h_cos] = ErgaenzeSchlag(h_sin, h_cos, Knoten, zLager1, zLager2, K_B, R, Winkel)

if R > (zLager2-zLager1)/2 
    %% Bestimmen wichtiger Punkte

    % finde Lagerpositionen innerhalb des Knoten-Vektors
    nKnoten = length(Knoten);
    nStart = find(abs(Knoten-zLager1) < 1e-6, 1, 'first');
    nEnd = find(abs(Knoten-zLager2) < 1e-6, 1, 'last');
    
    L = zLager2-zLager1;
    x0 = linspace(0,0,2*nKnoten);

    % Schlag zwischen Lagern, Modellierung als Kreisbogen mit Radius R
    x0(2*nStart-1:2:2*nEnd-1) = (R^2-(Knoten(nStart:nEnd)-zLager1-L/2).^2).^0.5 - (R^2-(L/2)^2)^0.5;
    x0(2*nStart:2:2*nEnd) = -(Knoten(nStart:nEnd)-zLager1-L/2)./(R^2-(Knoten(nStart:nEnd)-zLager1-L/2).^2).^0.5; %Dreh-FG ist +v', neg. VZ gehört zur Ableitung
    x0(2*nKnoten+2*nStart-1:2:2*nKnoten+2*nEnd-1) = (R^2-(Knoten(nStart:nEnd)-zLager1-L/2).^2).^0.5 - (R^2-(L/2)^2)^0.5;
    x0(2*nKnoten+2*nStart:2:2*nKnoten+2*nEnd) = (Knoten(nStart:nEnd)-zLager1-L/2)./(R^2-(Knoten(nStart:nEnd)-zLager1-L/2).^2).^0.5; %Dreh-FG ist -w', (-1)*(-1) = +1
        
    Trigger=1;
    % Stetige Fortfuehrung ausserhalb Lager
    x0(1:2:2*nStart-3) = (Knoten(1:nStart-1)-zLager1)*x0(2*nStart);
    x0(2:2:2*nStart-2) = x0(2*nStart);
    x0(2*nEnd+1:2:2*nKnoten-1) = (Knoten(nEnd+1:end)-zLager2)*x0(2*nEnd)*Trigger; %schlagfrei im Endstueck
    x0(2*nEnd+2:2:2*nKnoten) = x0(2*nEnd)*Trigger; %schlagfrei im Endstueck
    x0(2*nKnoten+1:2:2*nKnoten+2*nStart-3) = -(Knoten(1:nStart-1)-zLager1)*x0(2*nKnoten+2*nStart);
    x0(2*nKnoten+2:2:2*nKnoten+2*nStart-2) = x0(2*nKnoten+2*nStart);
    x0(2*nKnoten+2*nEnd+1:2:4*nKnoten-1) = -(Knoten(nEnd+1:end)-zLager2)*x0(2*nKnoten+2*nEnd)*Trigger; %schlagfrei im Endstueck
    x0(2*nKnoten+2*nEnd+2:2:4*nKnoten) = x0(2*nKnoten+2*nEnd)*Trigger; %schlagfrei im Endstueck

    %% Berechnung 'Last durch Schlag'
    h = K_B*x0.';
       
    h_sin = h_sin + [-sin(Winkel)*h(1:2*nKnoten); cos(Winkel)*h(2*nKnoten+1:end)];
    h_cos = h_cos + [cos(Winkel)*h(1:2*nKnoten); sin(Winkel)*h(2*nKnoten+1:end)];
    
else
    disp('Kruemmungsradius zu klein. Schlag wird zu 0 gesetzt.')
end



