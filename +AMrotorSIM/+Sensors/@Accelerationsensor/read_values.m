function [xdd_val,psixdd_val,ydd_val,psiydd_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        xdd_val = containers.Map('KeyType','double','ValueType','any');
        ydd_val = containers.Map('KeyType','double','ValueType','any');
        psixdd_val = containers.Map('KeyType','double','ValueType','any');
        psiydd_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.Position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_psix= rotor.get_gdof('psi_x',node_nr);
        dof_psiy= rotor.get_gdof('psi_y',node_nr);
        
        xdd_val(drehzahl)=res(drehzahl).X_dd(dof_x,:);
        ydd_val(drehzahl)=res(drehzahl).X_dd(dof_y,:);
        psixdd_val(drehzahl)=res(drehzahl).X_dd(dof_psix,:);
        psiydd_val(drehzahl)=res(drehzahl).X_dd(dof_psiy,:);

        end
end