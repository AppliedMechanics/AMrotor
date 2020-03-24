function [psix_val,psiy_val,psiz_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        psix_val = containers.Map('KeyType','double','ValueType','any');
        psiy_val = containers.Map('KeyType','double','ValueType','any');
        psiz_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor
        
        node_nr = rotor.find_node_nr(self.position);
        dof_psix= rotor.get_gdof('psi_x',node_nr);
        dof_psiy= rotor.get_gdof('psi_y',node_nr);
        dof_psiz= rotor.get_gdof('psi_z',node_nr);
        
        psix_val(drehzahl)=res(drehzahl).X(dof_psix,:);
        psiy_val(drehzahl)=res(drehzahl).X(dof_psiy,:);
        psiz_val(drehzahl)=res(drehzahl).X(dof_psiz,:);

        end
end