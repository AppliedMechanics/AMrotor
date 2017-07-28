function [InitialUnwuchtsMatrix,InitialSchlagMatrix] = approximate_initial_failures(obj,dataset,ESF1)

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
m = obj.cnfg.MasseRotorGesamt; %Rotormasse gesamt
L = obj.cnfg.Lagerabstand; %Lagerabstand
zUnwucht = obj.cnfg.zPosUnwucht; %%%%% eingang in funtion nicht bestimmmbar durch code, nutzer legt unwuchtsposition durch schätzungen fest
zSensor = obj.cnfg.zPosSensor;
uESF1=ESF1.uESF1;
zESF1=ESF1.zESF1;

% Aufstellen und Loesen des LGS
r = linspace(0,0,length(DrehzahlMess));
f = r; %Verstärkungsfkt. Unwucht
g = r; %Verstärkungsfkt. Schlag
uMess = interp1(zESF1,uESF1,zSensor,'spline');
uUnwucht = interp1(zESF1,uESF1,zUnwucht,'spline');

    eta = DrehzahlMess./60/f1;
    f = eta.^2./(1-eta.^2);
    g = 1./(1-eta.^2);
    r = RadiusMess.*exp(1i*PhaseMess);%% abziehen der Initialunwicht% schöaganteil ignoriert?

    
%% Berechnung des aktuellen Wellenzustands
A = [f.'/m1*uMess*uUnwucht,g.'];
x = A\r';


%% %% Aktuell gemessene Unwucht
% Phase Unwucht
phiUnwucht = atan2(imag(x(1)),real(x(1)));

BetragUnwucht = abs(x(1));

InitialUnwuchtsMatrix = [zUnwucht BetragUnwucht phiUnwucht ];

%% Aktuell gemessener quasi Schlag
% Phase Schalg
phiSchlag = atan2(imag(x(2)),real(x(2)));

% Radius Schlag

r0 = abs(x(2));

if zSensor > L/2
    R = abs(0.5*r0-(L-zSensor)/r0*(L/2-(L-zSensor)/2));
else
    R = abs(0.5*r0-zSensor/r0*(L/2-zSensor/2));
end

InitialSchlagMatrix = [ R phiSchlag ];

end