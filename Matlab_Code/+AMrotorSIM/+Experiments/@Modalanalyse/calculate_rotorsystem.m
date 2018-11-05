function calculate_rotorsystem(obj,nModes,drehzahl)

      disp('Berechne Modalanalyse Rotorsystem')

  obj.n_ew = nModes;

%==========================================================================
% aus Experiments.Campbell
[mat.A,mat.B] = obj.get_state_space_matrices(drehzahl/60*2*pi);
[V,D_tmp] = obj.perform_eigenanalysis(mat);
D = D_tmp;% D = get_positive_entries(D_tmp);
%==========================================================================
D = imag(D);
 
 %negative D / V Einträge wegwerfen --> nModes=nModes
 
 tmp = find(D >=0);
 tmp2 = sparse(size(V,1),length(tmp));
 for i = 1:length(tmp)
     EV_nr = tmp(i,1);
     tmp2(:,i) = V(:,EV_nr);
 end
 D = D(tmp);
 V = tmp2;
 
 V = real(obj.get_position_entries(V));
        
    %% Aussortierung der x werte aus dem EV mithilfe der get_dof Implementierung
    nNodes = obj.rotorsystem.rotor.mesh.nodes;
    
    Ev_lat = zeros(length(nNodes),size(V,2));

    for mode = 1:nModes
        for node = 1:length(nNodes)
            dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
            dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node);

                Ev_lat(node,mode)=sign(V(dof_u_x,mode))...
                *norm(V(dof_u_x,mode)+V(dof_u_y,mode));
        end
    end   
    obj.eigenVectors.lateral=Ev_lat;
    obj.eigenValues.lateral =D;
    
    %% Aussortierung der Torsionswerte aus dem EV mithilfe der get_dof Implementierung
    Ev_tor = zeros(length(nNodes),size(V,2));
    for node = 1:length(nNodes)
        dof_xi_z = obj.rotorsystem.rotor.get_gdof('psi_z',node);
        Ev_tor(node,:)= V(dof_xi_z,:);
    end
    obj.eigenVectors.torsional=Ev_tor;

end 
