function calculate_rotorsystem(obj,nModes,drehzahl)

      disp('Berechne Modalanalyse Rotorsystem')

  obj.n_ew = nModes;
  omega = drehzahl/60*2*pi;

%==========================================================================
% aus Experiments.Campbell
[mat.A,mat.B] = obj.get_state_space_matrices(omega);
% [mat.A,mat.B] = obj.get_state_space_matrices_reduced(omega);
[V,D] = obj.perform_eigenanalysis(mat);
%==========================================================================
D_tmp = imag(D);
 
 %negative D / V Eintr�ge wegwerfen --> nModes=nModes
 
 tmp = find(D_tmp >=0);
 tmp2 = sparse(size(V,1),length(tmp));
 for i = 1:length(tmp)
     EV_nr = tmp(i,1);
     tmp2(:,i) = V(:,EV_nr);
 end
 D = D(tmp);
 D_tmp = D_tmp(tmp);
 V = tmp2;
 
 V = obj.get_position_entries(V,mat);
 V_real = real(V);
        
    %% Aussortierung der x werte aus dem EV mithilfe der get_dof Implementierung
    nNodes = obj.rotorsystem.rotor.mesh.nodes;
    
    Ev_lat_x = zeros(length(nNodes),size(V_real,2));
    Ev_lat_y = Ev_lat_x;

    for mode = 1:nModes
        for node = 1:length(nNodes)
            dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node,mat.A);%1+4*(node-1)
            dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node,mat.A);%2+4*(node-1)

            Ev_lat_x(node,mode)=V_real(dof_u_x,mode);
            Ev_lat_y(node,mode)=V_real(dof_u_y,mode);
        end
    end   
    obj.eigenVectors.lateral_x=Ev_lat_x;
    obj.eigenVectors.lateral_y=Ev_lat_y;
    obj.eigenValues.lateral =D;
%     obj.eigenValues.full = V;
    
%     %% Aussortierung der Torsionswerte aus dem EV mithilfe der get_dof Implementierung
%     Ev_tor = zeros(length(nNodes),size(V_real,2));
%     for node = 1:length(nNodes)
%         dof_xi_z = obj.rotorsystem.rotor.get_gdof('psi_z',node);
%         Ev_tor(node,:)= V_real(dof_xi_z,:);
%     end
%     obj.eigenVectors.torsional=Ev_tor;

obj.eigenVectors.complex = V;

% finde EV, so wie sie durch die Sensorpositionen beobachtet werden koennen
% sortiere zunachst die EV aus, die zu starrkoerpermoden gehoeren

SensNodes = zeros(length(obj.rotorsystem.sensors),1);
Ev_Sens_lat_x = zeros(length(SensNodes),size(V,2));
Ev_Sens_lat_y = Ev_Sens_lat_x;
i=1;
for sensor = obj.rotorsystem.sensors
    SensNodes(i) = obj.rotorsystem.rotor.find_node_nr(sensor.Position);
    i=i+1;
end
for mode = 1:nModes
    for k = 1:length(SensNodes)
        node = SensNodes(k);
        dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node,mat.A);%1+4*(node-1)
        dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node,mat.A);%2+4*(node-1)
        Ev_Sens_lat_x(k,mode)=V(dof_u_x,mode);
        Ev_Sens_lat_y(k,mode)=V(dof_u_y,mode);
    end
end
obj.eigenVectors.Sensor.lat_x = Ev_Sens_lat_x;
obj.eigenVectors.Sensor.lat_y = Ev_Sens_lat_y;
end 
