function [Fx_val,My_val,Fy_val,Mx_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        Fx_val = containers.Map('KeyType','double','ValueType','any');
        Fy_val = containers.Map('KeyType','double','ValueType','any');
        Mx_val = containers.Map('KeyType','double','ValueType','any');
        My_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.Position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_psix= rotor.get_gdof('psi_x',node_nr);
        dof_psiy= rotor.get_gdof('psi_y',node_nr);
        
        Fx_val(drehzahl)=res(drehzahl).FBearing(dof_x,:);
        Fy_val(drehzahl)=res(drehzahl).FBearing(dof_y,:);
        Mx_val(drehzahl)=res(drehzahl).FBearing(dof_psix,:);
        My_val(drehzahl)=res(drehzahl).FBearing(dof_psiy,:);

        end

end