function calculate_rotorsystem(obj,nModes,drehzahl)

      disp('Berechne Modalanalyse Rotorsystem')

  obj.n_ew = nModes;
  omega = drehzahl/60*2*pi;

%==========================================================================
% aus Experiments.Campbell
[mat.A,mat.B] = obj.get_state_space_matrices(omega);
[V,D] = obj.perform_eigenanalysis(mat);
%==========================================================================
D_tmp = imag(D);
 
 %negative D / V Einträge wegwerfen --> nModes=nModes
 
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
            dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node,mat.A);
            dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node,mat.A);
            dof_u_z = obj.rotorsystem.rotor.get_gdof('u_z',node,mat.A);
            dof_psi_z = obj.rotorsystem.rotor.get_gdof('psi_z',node,mat.A);

            Ev_lat_x(node,mode)=V_real(dof_u_x,mode);
            Ev_lat_y(node,mode)=V_real(dof_u_y,mode);
            Ev_lat_z(node,mode)=V_real(dof_u_z,mode);
            Ev_tor_psi_z(node,mode)=V_real(dof_psi_z,mode);   
            
            CEv_lat_x(node,mode)=V(dof_u_x,mode);
            CEv_lat_y(node,mode)=V(dof_u_y,mode);
            CEv_lat_z(node,mode)=V(dof_u_z,mode);
            CEv_tor_psi_z(node,mode)=V(dof_psi_z,mode);   
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

end 
