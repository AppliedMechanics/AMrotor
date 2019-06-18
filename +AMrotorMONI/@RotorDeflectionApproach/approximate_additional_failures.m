function [Revisedimbalancemarix,Differentialimbalancematrix,RevisedCoupledSchlagMatrix,DifferentialCoupledSchlagMatrix,XRevisional,XDifferential]=approximate_additional_failures(obj,dataset,XInitial)


Schluessel=keys(dataset);

for i1=1:(size(keys(dataset),2))
    
        temp=dataset(Schluessel{i1});
        Zeit=temp('time');
        Tacho=temp('n');
        phi=temp('Phi');
        xPos=temp('s_x (Positionssensor Scheibe)');
        yPos=temp('s_y (Positionssensor Scheibe)');
    
        [DrehzahlMess(i1), Gleichlauf_Auslenkung(i1), Gegenlauf_Auslenkung(i1), StatischeAuslenkung(i1), fourier(i1)] = analyse_deflection_fourier_coeff(obj,Zeit,xPos,yPos,Tacho,phi);
             
        
end

% Rotorparameter
f1 = obj.cnfg.Eigenfrequenz; %Eigenfrequenz
m1 = obj.cnfg.ModaleMasse1EO; %Rotormasse des 1. Modes % amplitude erster mode ,modale masse
m = obj.cnfg.MasseRotorGesamt; %Rotormasse gesamt
L = obj.cnfg.Lagerabstand; %Lagerabstand
zUnwucht = obj.cnfg.zPosUnwucht; % Eingang in Funtion nicht bestimmmbar
                                 % durch Code, Nutzer legt Unwuchtsposition durch Schätzungen fest
zSensor = obj.cnfg.zPosSensor; % Axiale Position des Sensors
zLinkesLager = obj.cnfg.zLinkesLager;

uESF1=obj.ESF1.uESF1;
zESF1=obj.ESF1.zESF1;

    % Berechnet den Anteil der Unwucht aus der Initialisirungsmessung bei
    % der aktuelle Messung
%    U0_Initialisierungsmatix = interp1(zESF1,uESF1,InitialUnwucht(1),'spline')*InitialUnwucht(2)*exp(1i*InitialUnwucht(3));
    
    % Berechnet den Anteil des Schlags aus der Initialisirungsmessung bei
    % der aktuelle Messung
%    S0_Initialisierungsmatix = (-sqrt(InitialSchlag(1)^2-(L/2)^2)+sqrt(InitialSchlag(1)^2-(L/2-zSensor)^2))*exp(1i*InitialSchlag(2));
    % rechnet die Auswirkung einer Veschiebung des Sensors bei einer neuen
    % Messung für den Wert, den die Alte Messung an dieser Stelle gehabt 
    % hätte mit ein mi ein unter der Annahme: Wellenschlag kreissegment-förmig
    
    
    
    
    
% Aufstellen und Loesen des LGS
r = zeros(length(DrehzahlMess),1);
f = r; %Verstärkungsfkt. Unwucht
g = r; %Verstärkungsfkt. Schlag
uMess = interp1(zESF1,uESF1,zSensor,'spline');
uUnwucht = interp1(zESF1,uESF1,zUnwucht,'spline');

eta = DrehzahlMess.*2*pi/60/f1;
f = eta.^2./(1-eta.^2);
g = 1./(1-eta.^2);

    
%--------------------------------------------------------------------------    
%% Berechnung des aktuellen Wellenzustands
  rNeu = Gleichlauf_Auslenkung.';
  ANeu = [f.',g.'];
  xNeu = ANeu\rNeu; % Lösung überbestimmtes gleichungssystem
  % Verschieben der Unwucht entlang der Biegekurve
  xNeu(1) = xNeu(1)*m1/m/uMess/uUnwucht;
  xDiff(1) = xNeu(1)-XInitial(1,2);
  xDiff(2) = xNeu(2)-XInitial(2,2); % *uMess/uMessAlt;
  
%% Aktuell gemessene Unwucht    
% Phase Unwucht
phiUnwuchtNeu = atan2(imag(xNeu(1)),real(xNeu(1)));

BetragUnwuchtNeu = m1*abs(xNeu(1));

Revisedimbalancemarix = [zUnwucht BetragUnwuchtNeu phiUnwuchtNeu ];


%% Aktuell gemessener quasi Schlag
% Phase Schalg
phiSchlagNeu = atan2(imag(xNeu(2)),real(xNeu(2)));

% Radius Schlag

r0Neu = abs(xNeu(2));

if (zSensor-zLinkesLager) > L/2
    RNeu = abs(0.5*r0Neu-(L-(zSensor-zLinkesLager))/r0Neu*(L/2-(L-(zSensor-zLinkesLager))/2));
else
    RNeu = abs(0.5*r0Neu-(zSensor-zLinkesLager)/r0Neu*(L/2-(zSensor-zLinkesLager)/2));
end
% XKreisNeu=[0,zSensor,L];
% YKreisNeu=[0,r0Neu,0];
% [~, ~, RNeu] = circfit(XKreisNeu,YKreisNeu);

RevisedCoupledSchlagMatrix = [ RNeu phiSchlagNeu];

  
  
  
  
  
%--------------------------------------------------------------------------  
% %% Berechnung des differenz Wellenzustands
% rDiff = RadiusMess.*exp(1i*PhaseMess)-f./m1*uMess*U0_Initialisierungsmatix-g.*S0_Initialisierungsmatix;%% abziehen der Initialunwicht und Schlag Für Differenzmessung    
% ADiff = [f.'/m1*uMess*uUnwucht,g.'];
% xDiff = ADiff\rDiff';


%% Aktuelle Differenz Unwucht
% Phase Unwucht
phiUnwuchtDiff = atan2(imag(xDiff(1)),real(xDiff(1)));

BetragUnwuchtDiff = m1*abs(xDiff(1));

Differentialimbalancematrix = [zUnwucht BetragUnwuchtDiff phiUnwuchtDiff ];

%% Aktueller Differenz Schag
% Phase Schalg
phiSchlagDiff = atan2(imag(xDiff(2)),real(xDiff(2)));

% Radius Schlag

r0Diff = abs(xDiff(2));

if (zSensor-zLinkesLager) > L/2
    RDiff = abs(0.5*r0Diff-(L-(zSensor-zLinkesLager))/r0Diff*(L/2-(L-(zSensor-zLinkesLager))/2));
else
    RDiff = abs(0.5*r0Diff-(zSensor-zLinkesLager)/r0Diff*(L/2-(zSensor-zLinkesLager)/2));
end
% XKreisDiff=[0,zSensor,L];
% YKreisDiff=[0,r0Diff,0];
% [~, ~, RDiff] = circfit(XKreisDiff,YKreisDiff);
DifferentialCoupledSchlagMatrix = [ RDiff phiSchlagDiff];

%% ------------------------------------------------------------------------

% Übergabe Werte Für gekoppelte Berechnugn

XRevisional=[zUnwucht xNeu(1);zSensor xNeu(2)];
XDifferential=[zUnwucht xDiff(1);zSensor xDiff(2)];

end