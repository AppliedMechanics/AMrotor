function [psixd_val,psiyd_val,psizd_val] = read_values(self,experiment)
% Extracts the angular velocity values at the desired sensor position
%
%    :param experiment: Analysis type (Stationaere_Lsg, Hochlaufanalyse, ...)
%    :type experiment: object
%    :return: Values of the specific sensor

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
                % Initialisierung leerer Container
        psixd_val = containers.Map('KeyType','double','ValueType','any');
        psiyd_val = containers.Map('KeyType','double','ValueType','any');
        psizd_val = containers.Map('KeyType','double','ValueType','any');
        
        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.position);
        dof_psix = rotor.get_gdof('psi_x',node_nr);
        dof_psiy = rotor.get_gdof('psi_y',node_nr);
        dof_psiz = rotor.get_gdof('psi_z',node_nr);
        
        psixd_val(drehzahl)=res(drehzahl).X_d(dof_psix,:);
        psiyd_val(drehzahl)=res(drehzahl).X_d(dof_psiy,:);
        psizd_val(drehzahl)=res(drehzahl).X_d(dof_psiz,:);

        end
end