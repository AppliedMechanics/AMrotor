%% ========================================================================
% Angaben für den RPS
% JM: 20.11.2017

% ........Manuelle Eingabe Rotorparameter...

 cnfg.Lagerabstand = 0.60;                 %Abstand zwischen den beiden Auflagern in Meter
 cnfg.Steifigkeit= 1.2475e+4;              %210000e+6*pi*0.008^4/64;
 cnfg.Eigenfrequenz =  79.5005;            %Eigenfrequenz des Rotors in rad/sec.
 cnfg.ModaleMasse1EO = 1.9737;             % kg bei Laval gleich mit Gesammtmasse
 cnfg.MasseRotorGesamt = 1.9737;           % scheibe 6.6268 kg
 cnfg.zPosUnwucht = 0.5075;
 cnfg.zPosSensor = 0.5075;
 cnfg.zLinkesLager = 0.1;