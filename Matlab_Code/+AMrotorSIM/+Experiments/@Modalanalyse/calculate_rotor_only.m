function calculate_rotor_only(obj,n_modes,drehzahl)

  disp('Berechne Modalanalyse Rotor')

  obj.n_ew = n_modes;
  omega=drehzahl/60*2*pi;

  K=obj.rotorsystem.rotor.matrices.K;
  G=obj.rotorsystem.rotor.matrices.G;
  M=obj.rotorsystem.rotor.matrices.M;


 for n1 = 1:length(omega)   %coolere for-Schleife 

    G_rot = G.*omega(n1); %entsprechende Anpassung

    [V,tmp] = eigs(-K,M,nModes,'sm');
    [D,order] = sort(sqrt(diag(tmp)));
    % sorting
    for i = 1:length(order)
        tmp = V(:,i);
        V(:,i) = V(:,order(i));
        V(:,order(i)) = tmp;
    end
    
    
    [EV,EW] = polyeig(K,G_rot,M);

     [~,I]=sort((abs(EW())));

      EW=EW(I);
      EV=EV(:,I);


    %Aew(:,n1)=-imag(EW(1:2:s*4));

    %obj.eigenmatrizen.Aev_x=Aev_x; %Aussortierung der x werte aus dem EV mithilfe der get_dof implementieren
    Aev_x = zeros(2*length(obj.rotorsystem.rotor.mesh.nodes),size(EV,2));
    for node = 1:length(obj.rotorsystem.rotor.mesh.nodes)
        dof_u_x = obj.rotorsystem.rotor.get_gdof('u_x',node);
        dof_xi_x = obj.rotorsystem.rotor.get_gdof('xi_x',node);
        Aev_x(2*node-1,:)=EV(dof_u_x,:);
        Aev_x(2*node,:)=EV(dof_xi_x,:);
    end
    obj.eigenmatrizen.Aev_x=Aev_x;
    %obj.eigenmatrizen.Aew=Aew;
 end

end