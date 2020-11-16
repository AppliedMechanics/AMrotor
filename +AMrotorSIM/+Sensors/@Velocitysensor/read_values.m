function [xd_val,yd_val,zd_val] = read_values(self,experiment)
% Extracts the velocity values at the desired sensor position
%
%    :param experiment: Analysis type (Stationaere_Lsg, Hochlaufanalyse, ...)
%    :type experiment: object
%    :return: Values of the specific sensor

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        
        % Initialisierung leerer Container
        xd_val = containers.Map('KeyType','double','ValueType','any');
        yd_val = containers.Map('KeyType','double','ValueType','any');
        zd_val = containers.Map('KeyType','double','ValueType','any');
        
        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y = rotor.get_gdof('u_y',node_nr);
        dof_z = rotor.get_gdof('u_z',node_nr);
        
        xd_val(drehzahl)=res(drehzahl).X_d(dof_x,:);
        yd_val(drehzahl)=res(drehzahl).X_d(dof_y,:);
        zd_val(drehzahl)=res(drehzahl).X_d(dof_z,:);


        end
end