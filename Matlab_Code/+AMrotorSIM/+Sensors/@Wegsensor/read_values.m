function [x_val,psix_val,y_val,psiy_val] = read_values(self,rotorsystem)

    res = rotorsystem.time_result;
    rotor = rotorsystem.rotor;


        x_val = containers.Map('KeyType','double','ValueType','any');
        y_val = containers.Map('KeyType','double','ValueType','any');
        psix_val = containers.Map('KeyType','double','ValueType','any');
        psiy_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.Position);
        dof_x = rotorsystem.rotor.get_gdof('u_x',node_nr);
        dof_y= rotorsystem.rotor.get_gdof('u_y',node_nr);
        dof_psix= rotorsystem.rotor.get_gdof('psi_x',node_nr);
        dof_psiy= rotorsystem.rotor.get_gdof('psi_y',node_nr);
        
        x_val(drehzahl)=res(drehzahl).X(dof_x,:);
        y_val(drehzahl)=res(drehzahl).X(dof_y,:);
        psix_val(drehzahl)=res(drehzahl).X(dof_psix,:);
        psiy_val(drehzahl)=res(drehzahl).X(dof_psiy,:);

        end
end