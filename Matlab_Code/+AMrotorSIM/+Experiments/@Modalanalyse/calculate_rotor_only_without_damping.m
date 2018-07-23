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
    
    %% Aussortierung der x werte aus dem EV mithilfe der get_dof implementieren
    nNodes = obj.rotorsystem.rotor.mesh.nodes;
    
    Ev_lat = zeros(length(nNodes),size(V,2));
    for node = 1:length(nNodes)
        dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
        dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node);
        Ev_lat(node,:)=(V(dof_u_x,:)+V(dof_u_y,:))/2;
    end
    obj.eigenVectors.lateral=Ev_lat;
    obj.eigenValues.lateral =D;

end