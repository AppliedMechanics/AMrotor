function [Deflectionbased_ImbalanceMatrix,Deflectionbased_SchlagMatrix,Deflectionbased_ComparativeKupplungsversatzMatrix,Deflectionbased_KupplungsversatzMatrix] = calculate_Deflectionbased(obj,X,Bearing1_force,Bearing2_force)
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

%% Berechnung

KV_eqv = Bearing1_force(1) + Bearing2_force(1);
pos_rel_BKV = abs(Bearing2_force(1))/(abs(Bearing1_force(1))+abs(Bearing2_force(1)));
    z1_BKV = pos_rel_BKV*L + zLinkesLager;



U_eqv = Bearing1_force(2) + Bearing2_force(2);
U=X(1,2);
am = U_eqv/Eigenfrequenz^2 - U*m;
a = am/m;

a_Betrag = abs(a);
a_Phi = atan2(imag(a),real(a));
if (zPosSensor-zLinkesLager) > L/2
    R_a = abs(0.5*a_Betrag-(L-(zPosSensor-zLinkesLager))/a_Betrag*(L/2-(L-(zPosSensor-zLinkesLager))/2));
else
    R_a = abs(0.5*a_Betrag-(zPosSensor-zLinkesLager)/a_Betrag*(L/2-(zPosSensor-zLinkesLager)/2));
end

S_eqv = X(2,2);
k_M_k_K_BKV_vergl = S_eqv - a;
k1 = Eigenfrequenz^2*m1;
k_k_BKV_vergl = k_M_k_K_BKV_vergl*k1;





%% Ausgabe

Deflectionbased_KupplungsversatzMatrix = [z1_BKV , abs(KV_eqv), atan2(imag(KV_eqv),real(KV_eqv))];
Deflectionbased_SchlagMatrix = [R_a, a_Phi];
Deflectionbased_ComparativeKupplungsversatzMatrix = [zPosSensor, abs(k_k_BKV_vergl), atan2(imag(k_k_BKV_vergl),real(k_k_BKV_vergl))];
Deflectionbased_ImbalanceMatrix = [zPosSensor, abs(U*m), atan2(imag(U*m),real(U*m))];

end