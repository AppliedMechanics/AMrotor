classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem
      eigenmatrizen
      n_ew
      eigenVectors
      eigenValues
   end
   methods
       %Konstruktor
       function obj = Modalanalyse(a)
         if nargin == 0
           disp('Keine Modalanalyse möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end

      function calculate_rotor_only(obj,n_modes,drehzahl)
      
          disp('Berechne Modalanalyse Rotor')
          
          obj.n_ew = n_modes;
          omega=drehzahl/60*2*pi;
          %n_nodes=length(obj.rotorsystem.rotor.nodes);
          
          K=obj.rotorsystem.rotor.matrices.K;
          G=obj.rotorsystem.rotor.matrices.G;
          M=obj.rotorsystem.rotor.matrices.M;
          
          
         for n1 = 1:length(omega)

            G_rot = G.*omega(n1);

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
          
          %[obj.eigenmatrizen.Aev,obj.eigenmatrizen.Aew] = compute_EW_EV(obj.omega,obj.n_ew,K,G,M,n_nodes);
         %[obj.eigenmatrizen.Aev_x,obj.eigenmatrizen.Aev_y,obj.eigenmatrizen.Aev_alpha,obj.eigenmatrizen.Aev_beta,obj.eigenmatrizen.Aew,obj.eigenmatrizen.EVrot,obj.eigenmatrizen.EWrot] = compute_EW_EV(obj.omega,n_modes,K,G,M);
      end
 
      function calculate_rotorsystem(obj,n_modes)
      
          disp('Berechne Modalanalyse Rotorsystem')
          
          obj.n_ew = n_modes;
          
          [obj.eigenVectors.x,obj.eigenValues.x] = getEigenform(obj,n_modes,'x');
          [obj.eigenVectors.y,obj.eigenValues.y] = getEigenform(obj,n_modes,'y');
          
      
      end
      
   end
   methods(Access=private)
       
   end
end
