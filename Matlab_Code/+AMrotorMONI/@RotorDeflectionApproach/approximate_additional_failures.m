function [Revisedimbalancemarix,Differentialimbalancematrix,RevisedCoupledSchlagMatrix,DifferentialCoupledSchlagMatrix]=approximate_additional_failures(obj,dataset,ESF1,InitialUnwucht,InitialSchlag)


for i1=1:size(dataset,1)    
        Input=permute(dataset,[2 3 1]);
        [DrehzahlMess(i1), RadiusMess(i1), PhaseMess(i1), OffsetXMess(i1), OffsetYMess(i1)] = analyse_deflection_fourier_coeff(obj,Input(:,:,i1));
        
        RadiusMess(i1) = RadiusMess(i1)/1000;
        PhaseMess(i1) = PhaseMess(i1) *pi/180;
        OffsetXMess(i1) = OffsetXMess(i1)/1000;
        OffsetYMess(i1) = OffsetYMess(i1)/1000;
        
end

% Rotorparameter
f1 = obj.cnfg.Eigenfrequenz*2*pi; %Eigenfrequenz
m1 = obj.cnfg.ModaleMasse1EO; %Rotormasse des 1. Modes % amplitude erster mode ,modale masse
L = obj.cnfg.Lagerabstand; %Lagerabstand
zUnwucht = obj.cnfg.zPosUnwucht; % Eingang in Funtion nicht bestimmmbar
                                 % durch Code, Nutzer legt Unwuchtsposition durch Schätzungen fest
zSensor = obj.cnfg.zPosSensor; % Axiale Position des Sensors


uESF1=ESF1.uESF1;
zESF1=ESF1.zESF1;

    % Berechnet den Anteil der Unwucht aus der Initialisirungsmessung bei
    % der aktuelle Messung
   U0_Initialisierungsmatix = interp1(zESF1,uESF1,InitialUnwucht(1),'spline')*InitialUnwucht(2)*exp(1i*InitialUnwucht(3));
    
    % Berechnet den Anteil des Schlags aus der Initialisirungsmessung bei
    % der aktuelle Messung
   S0_Initialisierungsmatix = (-sqrt(InitialSchlag(1)^2-(L/2)^2)+sqrt(InitialSchlag(1)^2-(L/2-zSensor)^2))*exp(1i*InitialSchlag(2));
    % rechnet die Auswirkung einer Veschiebung des Sensors bei einer neuen
    % Messung für den Wert, den die Alte Messung an dieser Stelle gehabt 
    % hätte mit ein mi ein unter der Annahme: Wellenschlag kreissegment-förmig
    
    
    
    
    
% Aufstellen und Loesen des LGS
r = linspace(0,0,length(DrehzahlMess));
f = r; %Verstärkungsfkt. Unwucht
g = r; %Verstärkungsfkt. Schlag
uMess = interp1(zESF1,uESF1,zSensor,'spline');
uUnwucht = interp1(zESF1,uESF1,zUnwucht,'spline');

eta = DrehzahlMess./60/f1;
f = eta.^2./(1-eta.^2);
g = 1./(1-eta.^2);

    
%--------------------------------------------------------------------------    
%% Berechnung des aktuellen Wellenzustands
  rNeu = RadiusMess.*exp(1i*PhaseMess);
  ANeu = [f.'/m1*uMess*uUnwucht,g.'];
  xNeu = ANeu\rNeu'; % Lösung überbestimmtes gleichungssystem

  
%% Aktuell gemessene Unwucht    
% Phase Unwucht
phiUnwuchtNeu = atan2(imag(xNeu(1)),real(xNeu(1)));

BetragUnwuchtNeu = abs(xNeu(1));

Revisedimbalancemarix = [zUnwucht BetragUnwuchtNeu phiUnwuchtNeu ];


%% Aktuell gemessener quasi Schlag
% Phase Schalg
phiSchlagNeu = atan2(imag(xNeu(2)),real(xNeu(2)));

% Radius Schlag

r0Neu = abs(xNeu(2));

if zSensor > L/2
    RNeu = abs(0.5*r0Neu-(L-zSensor)/r0Neu*(L/2-(L-zSensor)/2));
else
    RNeu = abs(0.5*r0Neu-zSensor/r0Neu*(L/2-zSensor/2));
end

RevisedCoupledSchlagMatrix = [ RNeu phiSchlagNeu];

  
  
  
  
  
%--------------------------------------------------------------------------  
%% Berechnung des differenz Wellenzustands
rDiff = RadiusMess.*exp(1i*PhaseMess)-f./m1*uMess*U0_Initialisierungsmatix-g.*S0_Initialisierungsmatix;%% abziehen der Initialunwicht und Schlag Für Differenzmessung    
ADiff = [f.'/m1*uMess*uUnwucht,g.'];
xDiff = ADiff\rDiff';


%% Aktuelle Differenz Unwucht
% Phase Unwucht
phiUnwuchtDiff = atan2(imag(xDiff(1)),real(xDiff(1)));

BetragUnwuchtDiff = abs(xDiff(1));

Differentialimbalancematrix = [zUnwucht-InitialUnwucht(1) BetragUnwuchtDiff phiUnwuchtDiff ];

%% Aktueller Differenz Schag
% Phase Schalg
phiSchlagDiff = atan2(imag(xDiff(2)),real(xDiff(2)));

% Radius Schlag

r0Diff = abs(xDiff(2));

if zSensor > L/2
    RDiff = abs(0.5*r0Diff-(L-zSensor)/r0Diff*(L/2-(L-zSensor)/2));
else
    RDiff = abs(0.5*r0Diff-zSensor/r0Diff*(L/2-zSensor/2));
end

DifferentialCoupledSchlagMatrix = [ RDiff phiSchlagDiff];

end