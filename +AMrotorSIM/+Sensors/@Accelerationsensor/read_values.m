% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [xdd_val,ydd_val,zdd_val] = read_values(self,experiment)
% Extracts the acceleration values at the desired sensor position
%
%    :param experiment: Analysis type (Stationaere_Lsg, Hochlaufanalyse, ...) ????
%    :type experiment: object
%    :return: Values of the specific sensor

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        xdd_val = containers.Map('KeyType','double','ValueType','any');
        ydd_val = containers.Map('KeyType','double','ValueType','any');
        zdd_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y = rotor.get_gdof('u_y',node_nr);
        dof_z = rotor.get_gdof('u_z',node_nr);
        
        xdd_val(drehzahl)=res(drehzahl).X_dd(dof_x,:);
        ydd_val(drehzahl)=res(drehzahl).X_dd(dof_y,:);
        zdd_val(drehzahl)=res(drehzahl).X_dd(dof_z,:);
        end
end