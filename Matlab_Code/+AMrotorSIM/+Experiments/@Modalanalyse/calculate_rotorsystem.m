function calculate_rotorsystem(obj,nModes,drehzahl)

      disp('Berechne Modalanalyse Rotorsystem')

  obj.n_ew = nModes;

  ss_A=obj.rotorsystem.systemmatrices.ss_A;
  ss_B=obj.rotorsystem.systemmatrices.ss_B;


 %[V,D_tmp] = eigs(-ss_A,ss_B,2*nModes,'sm');
 [V,D_tmp] = eigs(ss_B,ss_A,2*nModes,'sm');
% [D,order] = sort(imag(diag(D_tmp)));
 D = imag(diag(D_tmp));
 
 %negative D / V Einträge wegwerfen --> nModes=nModes
 
 tmp = find(D >=0);
 tmp2 = sparse(size(V,1),length(tmp));
 for i = 1:length(tmp)
     EV_nr = tmp(i,1)
     tmp2(:,i) = V(:,EV_nr);
 end
 V = tmp2;

    % sorting
%     for i = 1:length(order)
%         tmp = V(:,i);
%         V(:,i) = V(:,order(i));
%         V(:,order(i)) = tmp;
%     end
        V=real(V(1:end/2,:));
        
    %% Aussortierung der x werte aus dem EV mithilfe der get_dof Implementierung
    nNodes = obj.rotorsystem.rotor.mesh.nodes;
    
    Ev_lat = zeros(length(nNodes),size(V,2));
%     for node = 1:length(nNodes)
%         dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
%         dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node);
%         Ev_lat(node,:)=norm(V(dof_u_x,:)+V(dof_u_y,:));
%     end
    for mode = 1:nModes
        for node = 1:length(nNodes)
            dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
            dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node);
%             if sign(V(dof_u_x,mode)) == -1 || sign(V(dof_u_y,mode)) == -1
%                Ev_lat(node,mode)=-norm(V(dof_u_x,mode)+V(dof_u_y,mode));
%             else
%                Ev_lat(node,mode)=norm(V(dof_u_x,mode)+V(dof_u_y,mode));
%             end

                Ev_lat(node,mode)=sign(V(dof_u_x,mode))...
                *norm(V(dof_u_x,mode)+V(dof_u_y,mode));
        end
    end   
    obj.eigenVectors.lateral=Ev_lat;
    obj.eigenValues.lateral =D;
    
    %% Aussortierung der Torsionswerte aus dem EV mithilfe der get_dof Implementierung
    Ev_tor = zeros(length(nNodes),size(V,2));
    for node = 1:length(nNodes)
        dof_xi_z = obj.rotorsystem.rotor.get_gdof('xi_z',node);
        Ev_tor(node,:)= V(dof_xi_z,:);
    end
    obj.eigenVectors.torsional=Ev_tor;
    %obj.eigenValues.torsion =T;
end 
