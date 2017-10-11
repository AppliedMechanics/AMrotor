classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem
      
      n_ew
      omega
      eigenmatrizen
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
          obj.omega=drehzahl/60*2*pi;
          %n_nodes=length(obj.rotorsystem.rotor.nodes);
          
          K=obj.rotorsystem.rotor.matrizen.K;
          G=obj.rotorsystem.rotor.matrizen.G;
          M=obj.rotorsystem.rotor.matrizen.M;
          
          
         for n1 = 1:length(obj.omega)

            G_rot = G.*obj.omega(n1);

            [EV,EW] = polyeig(K,G_rot,M);

             [~,I]=sort((abs(EW())));
             
              EW=EW(I);
              EV=EV(:,I);
             
             for s = 1:obj.n_ew

                 Aev_x(:,s,n1)=EV(1:2:end/2,s*4-3);
                 Aev_alpha(:,s,n1)=EV(2:2:end/2,s*4-3);
                 Aev_y(:,s,n1)=EV(end/2+1:2:end,s*4-3);
                 Aev_beta(:,s,n1)=EV(end/2+2:2:end,s*4-3);

             end
             
            Aew(:,n1)=-imag(EW(1:2:s*4));
             
            obj.eigenmatrizen.Aev_x=Aev_x;
            obj.eigenmatrizen.Aew=Aew;
         end
          
          %[obj.eigenmatrizen.Aev,obj.eigenmatrizen.Aew] = compute_EW_EV(obj.omega,obj.n_ew,K,G,M,n_nodes);
         %[obj.eigenmatrizen.Aev_x,obj.eigenmatrizen.Aev_y,obj.eigenmatrizen.Aev_alpha,obj.eigenmatrizen.Aev_beta,obj.eigenmatrizen.Aew,obj.eigenmatrizen.EVrot,obj.eigenmatrizen.EWrot] = compute_EW_EV(obj.omega,n_modes,K,G,M);
      end
 
      function calculate_rotorsystem(obj,n_modes,drehzahl)
      
          disp('Berechne Modalanalyse Rotorsystem')
          
          obj.n_ew = n_modes;
          obj.omega=drehzahl/60*2*pi;
          
          K=obj.rotorsystem.systemmatrizen.K;
          G=obj.rotorsystem.systemmatrizen.G;
          M=obj.rotorsystem.systemmatrizen.M;
          
          n_nodes=length(obj.rotorsystem.rotor.nodes);
          
          [obj.eigenmatrizen.Aev,obj.eigenmatrizen.Aew] = compute_EW_EV(obj.omega,obj.n_ew,K,G,M,n_nodes);

         %[obj.eigenmatrizen.Aev_x,obj.eigenmatrizen.Aev_y,obj.eigenmatrizen.Aev_alpha,obj.eigenmatrizen.Aev_beta,obj.eigenmatrizen.Aew,obj.eigenmatrizen.EVrot,obj.eigenmatrizen.EWrot] = compute_EW_EV(obj.omega,n_modes,K,G,M);
      
      end
      
      function calculate_rotorsystem_ss(obj,n_modes,drehzahl) %ss = State space, Zustandsraum (-trafo)
      
          disp('Berechne Modalanalyse Rotorsystem')
          
          obj.n_ew = n_modes;
          obj.omega=drehzahl/60*2*pi;
      
          nodes=obj.rotorsystem.rotor.nodes;
          n_nodes=length(nodes);
          
          
          for n1 = 1:length(obj.omega)

             ss=obj.rotorsystem.systemmatrizen.ss+obj.rotorsystem.systemmatrizen.ss_G*n1;

             indizes = 1:2*4*n_nodes;
             ss_mech = ss(indizes,indizes); % 4 --> Die vier werte der Verschiebung s_x, s_z, beta, alpha
              
             opts.tol = 1e-4;
             opts.isreal = 1;
             [V,D] = eigs(ss_mech,n_modes*4,'sm',opts);  
             %[V,D] = eig(ss_mech);
             
             obj.eigenmatrizen.V(:,:,n1) = V;
             obj.eigenmatrizen.D(:,:,n1) = D;
          end   
      end
      
   end
   methods(Access=private)
       
   end
end