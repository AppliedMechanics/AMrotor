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
        
        Fx_val(drehzahl)=res(drehzahl).F(dof_x,:);
        Fy_val(drehzahl)=res(drehzahl).F(dof_y,:);
        Mx_val(drehzahl)=res(drehzahl).F(dof_psix,:);
        My_val(drehzahl)=res(drehzahl).F(dof_psiy,:);

        end

% load = self.load;
% x_val = containers.Map('KeyType','double','ValueType','any');
% y_val = containers.Map('KeyType','double','ValueType','any');
% 
% for rpmCurr = experiment.drehzahlen
%     % load_node = self.rotor.find_node_nr(load.position);
%     % [node.q, node.qd, node.qdd] = self.find_state_vector(load.position,Z,qdotdot);
%     % node.omega = node.qd(6);
%     cnfg_artsens.name = 'Artificial Sensor';
%     cnfg_artsens.position = load.Position;
%     % cnfg_artsens.type = 'Displacementsensor';
%     
%     % displacement
%     d = AMrotorSIM.Sensors.Displacementsensor(cnfg_artsens);
%     [x_pos,beta_pos,y_pos,alpha_pos] = d.read_values(experiment);
%     node.q = [x_pos; y_pos; 0; alpha_pos; beta_pos; 0];
%     
%     %velocity
%     % cnfg_artsens.type = 'Velocitysensor';
%     v = AMrotorSIM.Sensors.Velocitysensor(cnfg_artsens);
%     [xd_pos,betad_pos,yd_pos,alphad_pos] = v.read_values(experiment);
%     node.qd = [xd_pos; yd_pos; 0; alphad_pos; betad_pos; 0];
%     
%     %acceleration
%     % cnfg_artsens.type = 'Accelerationsensor';
%     a = AMrotorSIM.Sensors.Accelerationsensor(cnfg_artsens);
%     [xdd_pos,betadd_pos,ydd_pos,alphadd_pos] = a.read_values(experiment);
%     node.qdd = [xdd_pos; ydd_pos; 0; alphadd_pos; betadd_pos; 0];
%     
%     load.create_ele_loc_matrix
%     h = load.get_loc_load_vec(time,node);
%     
%     x_val(rpmCurr) = h(1);
%     y_val(rpmCurr) = h(2);
%     
% end

end