function [Fx_val,Fy_val,Fz_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        Fx_val = containers.Map('KeyType','double','ValueType','any');
        Fy_val = containers.Map('KeyType','double','ValueType','any');
        Fz_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.Position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_z= rotor.get_gdof('u_z',node_nr);
        
        Fx_val(drehzahl)=res(drehzahl).Fcontroller(dof_x,:);
        Fy_val(drehzahl)=res(drehzahl).Fcontroller(dof_y,:);
        Fz_val(drehzahl)=res(drehzahl).Fcontroller(dof_z,:);
        end
end