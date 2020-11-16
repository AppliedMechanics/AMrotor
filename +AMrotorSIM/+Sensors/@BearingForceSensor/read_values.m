function [Fx_val,Fy_val,Fz_val] = read_values(self,experiment)
% Extracts the force values (from bearings) at the desired sensor position
%
%    :param experiment: Analysis type (Stationaere_Lsg, Hochlaufanalyse, ...) 
%    :type experiment: object
%    :return: Values of the specific sensor

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        Fx_val = containers.Map('KeyType','double','ValueType','any');
        Fy_val = containers.Map('KeyType','double','ValueType','any');
        Fz_val = containers.Map('KeyType','double','ValueType','any');
        
        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_z= rotor.get_gdof('u_z',node_nr);
        
        Fx_val(drehzahl)=res(drehzahl).FBearing(dof_x,:);
        Fy_val(drehzahl)=res(drehzahl).FBearing(dof_y,:);
        Fz_val(drehzahl)=res(drehzahl).FBearing(dof_z,:);

        end

end