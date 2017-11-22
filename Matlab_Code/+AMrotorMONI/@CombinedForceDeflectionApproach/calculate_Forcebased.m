function [Kupplungsbased_KupplungsversatzMatrix,Kupplungsbased_SchlagMatrix,Kupplungsbased_ComparativeImbalancematrix,Kupplungsbased_Imbalancematrix] = calculate_Forcebased(obj,X,Bearing1_force,Bearing2_force)

% X  =   [zUnwuchtPositio KomplexeUwucht[m]; zSensorPosition KomplexerSchlag+KupplungsversatzAuslenkung[m]]
% Bearing1_force = [KomplexeKupplungsversatzKraft[N]; KomplexeEquivalenteUnwucht[N]]
% Bearing2_force = [KomplexeKupplungsversatzKraft[N]; KomplexeEquivalenteUnwucht[N]]

zPosUnwucht = obj.cnfg.zPosUnwucht;
zPosSensor = obj.cnfg.zPosSensor; %%% == zPosUnwucht!
Eigenfrequenz = obj.cnfg.Eigenfrequenz;
m1 = obj.cnfg.ModaleMasse1EO;  % kg bei Laval gleich mit Gesammtmasse
m = obj.cnfg.MasseRotorGesamt;
L = obj.cnfg.Lagerabstand;
zLinkesLager = obj.cnfg.zLinkesLager;


k1 = Eigenfrequenz^2.*m1;    %Steifigkeit der ersten Mode



KV_eqv = Bearing1_force(1) + Bearing2_force(1);
pos_rel_BKV = abs(Bearing2_force(1))/(abs(Bearing1_force(1))+abs(Bearing2_force(1)));
    z1_BKV = pos_rel_BKV*L + zLinkesLager;
%--------------------------------------------------------------------------
a_eqv = X(2,2);

a = a_eqv - (1/k1)*KV_eqv; %Äquivalenter Schlag - Auslenkung durch Kupplungsversatz


%--------------------------------------------------------------------------
U_eqv = Bearing1_force(2) + Bearing2_force(2);
U_real = U_eqv/Eigenfrequenz^2 - a*m;           
U_vergleich = m*X(1,2);

%% Ausgabe



Kupplungsbased_KupplungsversatzMatrix = [z1_BKV ,abs(KV_eqv), atan2(imag(KV_eqv),real(KV_eqv)) ];

a_Betrag = abs(a);
a_Phi = atan2(imag(a),real(a));
if (zPosSensor-zLinkesLager) > L/2
    R_a = abs(0.5*a_Betrag-(L-(zPosSensor-zLinkesLager))/a_Betrag*(L/2-(L-(zPosSensor-zLinkesLager))/2));
else
    R_a = abs(0.5*a_Betrag-(zPosSensor-zLinkesLager)/a_Betrag*(L/2-(zPosSensor-zLinkesLager)/2));
end

Kupplungsbased_SchlagMatrix = [R_a,a_Phi];

Kupplungsbased_ComparativeImbalancematrix = [zPosSensor , abs(U_real), atan2(imag(U_real),real(U_real)) ];

Kupplungsbased_Imbalancematrix = [zPosSensor , abs(U_vergleich),atan2(imag(U_vergleich),real(U_vergleich))];

end