function calculate_rotor_only_without_damping(obj,nModes)

  disp('Berechne Modalanalyse Rotor')

  obj.n_ew = nModes;

  K=obj.rotorsystem.rotor.matrices.K;
  M=obj.rotorsystem.rotor.matrices.M;


 [V,tmp] = eigs(-K,M,nModes,'sm');
 [D,order] = sort(sqrt(diag(tmp)));
    % sorting
    for i = 1:length(order)
        tmp = V(:,i);
        V(:,i) = V(:,order(i));
        V(:,order(i)) = tmp;
    end
    
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
            if sign(V(dof_u_x,mode)) == -1 || sign(V(dof_u_y,mode)) == -1
               Ev_lat(node,mode)=-norm(V(dof_u_x,mode)+V(dof_u_y,mode));
            else
               Ev_lat(node,mode)=norm(V(dof_u_x,mode)+V(dof_u_y,mode));
            end
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