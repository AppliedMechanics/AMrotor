function calculate_rotor_only(obj,nModes,drehzahl)

    disp('Berechne Modalanalyse Rotor')

    obj.n_ew = nModes;
    omega=drehzahl/60*2*pi;

    K=obj.rotorsystem.rotor.matrices.K;
    D=obj.rotorsystem.rotor.matrices.D;
    G=obj.rotorsystem.rotor.matrices.G;
    M=obj.rotorsystem.rotor.matrices.M;

    ss_A = [D,M;M,sparse(size(M,1),size(M,2))];
    ss_B =[K,sparse(size(K,1),size(K,2));sparse(size(M,1),size(M,2)),-M];
    ss_AG =[G,sparse(size(G,1),size(G,2));...
        sparse(size(G,1),size(G,2)),sparse(size(G,1),size(G,2))];

    ss_A=ss_A+ss_AG*omega;

    [V,D_tmp] = eigs(ss_B,ss_A,2*nModes,'sm');

     D = imag(diag(D_tmp));

    %negative D / V Einträge wegwerfen --> nModes=nModes

     tmp = find(D >=0);
     tmp2 = sparse(size(V,1),length(tmp));
     for i = 1:length(tmp)
         EV_nr = tmp(i,1)
         tmp2(:,i) = V(:,EV_nr);
     end
     V = tmp2;

     V=real(V(1:end/2,:));

    %% Aussortierung der x werte aus dem EV mithilfe der get_dof Implementierung
    nNodes = obj.rotorsystem.rotor.mesh.nodes;

    Ev_lat = zeros(length(nNodes),size(V,2));

    for mode = 1:nModes
        for node = 1:length(nNodes)
            dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
            dof_u_y = obj.rotorsystem.rotor.get_gdof('u_y',node);

                Ev_lat_x(node,mode)=V(dof_u_x,mode);
                Ev_lat_y(node,mode)=V(dof_u_y,mode);
        end
    end   
    obj.eigenVectors.lateral_x=Ev_lat_x;
    obj.eigenValues.lateral =D;

end