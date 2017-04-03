function [h_sin, h_cos] = ErgaenzeVersatzEinseitigeKupplung(h_sin, h_cos, Knoten, zKupplung, b, PhiB, gamma, PhiGamma)

% b: Translatorischer Versatz, Winkel: phiB
% gamma: winkliger Versatz, Winkel: PhiGamma

load Kupplungsparameter.mat
EI = k_Kup*l_Kup^3/12;

nPos=find(Knoten==zKupplung,1,'first');
if isempty(nPos)==1
    error('Starre Kupplung sitzt nicht an Knoten');
end

hF1 = linspace(0,0,2*length(Knoten)).';
hF2 = linspace(0,0,2*length(Knoten)).';

% Fehlermatrix im fehlerfesten KOS
hF1(2*nPos-1:2*nPos) = EI*[-12/l_Kup^3; -6/l_Kup^2]*b;
hF2(2*nPos-1:2*nPos) = EI*[-6/l_Kup^2; -4/l_Kup]*gamma;

% Vorbereitung Werte fuer Berechnung im inertialen KOS
hF3=hF1;
hF4=hF2;
for n=2:2:length(hF3)
    hF3(n)=-hF3(n);
    hF4(n)=-hF4(n);
end

%Antragen im inertialfesten System als sin/cos-Anteil
h_cos=h_cos+[cos(PhiB)*hF1+cos(PhiGamma)*hF2; sin(PhiB)*hF3+sin(PhiGamma)*hF4];
h_sin=h_sin+[-sin(PhiB)*hF1-sin(PhiGamma)*hF2; cos(PhiB)*hF3+cos(PhiGamma)*hF4];

%Alte Fassung: hier sollte Phasenwinkel PhiGamma=0 eine Drehung um +x-Achse
%bedeuten. In komplexer Schreibweise des Problems nicht sinnvoll!
% h_cos=h_cos+[cos(PhiB)*hF1+cos(PhiGamma-pi/2)*hF2; sin(PhiB)*hF3+sin(PhiGamma-pi/2)*hF4];
% h_sin=h_sin+[-sin(PhiB)*hF1-sin(PhiGamma-pi/2)*hF2; cos(PhiB)*hF3+cos(PhiGamma-pi/2)*hF4];

end




