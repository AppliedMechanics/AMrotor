%% Compute Rotor
import AMrotorSIM.*
Config_Sim_freefree_optimization

r=Rotorsystem(cnfg,'MLPS-System');
r.assemble;
r.rotor.assemble_fem;
[M,D,~,K] = r.assemble_system_matrices(0);
% save ./Auswertungen/free_free_Vergleich_Sim_Exp/Simulation_Matrices M D K r
% clear M D K Sensor

%% get FRF from MDK
inposition = 460e-3; 
outposition = 414e-3;
InputString = {'460mm'}; % Positionen des Inputs
OutputString = {'414mm'}; % Positionen des Outputs
disp(convertStringsToChars(strcat('Sim, Input ',InputString)))
disp(convertStringsToChars(strcat('Sim, Output ',OutputString)))

indof = zeros(size(inposition));
outdof = zeros(size(outposition));
for k = 1:length(inposition)
    position = inposition(k);
    node_nr = r.rotor.find_node_nr(position);
    indof(k) = (node_nr-1)*6+1;
end
for k = 1:length(outposition)
    position = outposition(k);
    node_nr = r.rotor.find_node_nr(position);
    outdof(k) = (node_nr-1)*6+1;
end


fFEM=(0:0.25:400)';
HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'a')); % ACCELERATION mck2frf liefert konjugiert komplexen Wert der FRF