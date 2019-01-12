function [xd_val,psixd_val,yd_val,psiyd_val] = read_values(self,experiment)

    res = experiment.result;
    rotor = experiment.rotorsystem.rotor;
        
        % Initialisierung leerer Container
        xd_val = containers.Map('KeyType','double','ValueType','any');
        yd_val = containers.Map('KeyType','double','ValueType','any');
        psixd_val = containers.Map('KeyType','double','ValueType','any');
        psiyd_val = containers.Map('KeyType','double','ValueType','any');

        drehzahlvektor = cell2mat(keys(res));
        for drehzahl = drehzahlvektor

        node_nr = rotor.find_node_nr(self.Position);
        dof_x = rotor.get_gdof('u_x',node_nr);
        dof_y= rotor.get_gdof('u_y',node_nr);
        dof_psix= rotor.get_gdof('psi_x',node_nr);
        dof_psiy= rotor.get_gdof('psi_y',node_nr);
        
        xd_val(drehzahl)=res(drehzahl).X_d(dof_x,:);
        yd_val(drehzahl)=res(drehzahl).X_d(dof_y,:);
        psixd_val(drehzahl)=res(drehzahl).X_d(dof_psix,:);
        psiyd_val(drehzahl)=res(drehzahl).X_d(dof_psiy,:);

        end
end