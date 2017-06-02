function [h_sin, h_cos] = ErgaenzeVersatzStarreKupplung(h_sin, h_cos, Knoten, E, Geometrie2, zKupplung, b, PhiB, gamma, PhiGamma,Kupplungsseite)

% b: Translatorischer Versatz, Winkel: phiB
% gamma: winkliger Versatz, Winkel: PhiGamma

nPos=find(Knoten==zKupplung,1,'first');
if isempty(nPos)==1
    error('Starre Kupplung sitzt nicht an Knoten');
end

hF1 = linspace(0,0,2*length(Knoten)).';
hF2 = linspace(0,0,2*length(Knoten)).';
if Kupplungsseite == 'r' %Versatz am rechten Rand des finiten Elements
    % Aequivalente Last im jeweiligen fehlerfesten KOS
    l_Ele=Knoten(nPos)-Knoten(nPos-1);
    nGeometrie=find(Geometrie2(:,1)<Knoten(nPos),1,'last');
    hF1(2*nPos-3:2*nPos) = E*pi*Geometrie2(nGeometrie,2)^4/4*[12/l_Ele^3; 6/l_Ele^2; -12/l_Ele^3; 6/l_Ele^2]*b;
    hF2(2*nPos-3:2*nPos) = E*pi*Geometrie2(nGeometrie,2)^4/4*[-6/l_Ele^2; -2/l_Ele; 6/l_Ele^2; -4/l_Ele]*gamma;
        
else if Kupplungsseite == 'l' %Versatz am linken Rand des FE, dass an rechter Kupplungsseite angrenzt
        %Aequivalente Last im jeweiligen fehlerfesten KOS
        nPos=nPos+1;
        l_Ele=Knoten(nPos)-Knoten(nPos-1);
        nGeometrie=find(Geometrie2(:,1)<Knoten(nPos),1,'last');
        hF1(2*nPos-3:2*nPos) = E*pi*Geometrie2(nGeometrie,2)^4/4*[-12/l_Ele^3; -6/l_Ele^2; 12/l_Ele^3; -6/l_Ele^2]*b;
        hF2(2*nPos-3:2*nPos) = E*pi*Geometrie2(nGeometrie,2)^4/4*[-6/l_Ele^2; -4/l_Ele; 6/l_Ele^2; -2/l_Ele]*gamma;
    else
        error('Seite des Kupplungsfehlers unbekannt')
    end
end

hF3=hF1;
hF4=hF2;
for n=2:2:length(hF3)
    hF3(n)=-hF3(n);
    hF4(n)=-hF4(n);
end

%Antragen im inertialfesten System als sin/cos-Anteil
h_cos=h_cos+[cos(PhiB)*hF1+cos(PhiGamma)*hF2; sin(PhiB)*hF3+sin(PhiGamma)*hF4];
h_sin=h_sin+[-sin(PhiB)*hF1-sin(PhiGamma)*hF2; cos(PhiB)*hF3+cos(PhiGamma)*hF4];

end




