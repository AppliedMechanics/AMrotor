function [x_val,y_val,z_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        x_val = containers.Map('KeyType','double','ValueType','any');
        y_val = containers.Map('KeyType','double','ValueType','any');
        z_val = containers.Map('KeyType','double','ValueType','any');


        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_z= rotor.get_gdof('u_z',node_nr);
        
        x_val(drehzahl)=res(drehzahl).X(dof_x,:);
        y_val(drehzahl)=res(drehzahl).X(dof_y,:);
        z_val(drehzahl)=res(drehzahl).X(dof_z,:);

        end
end