classdef Campbell < handle
   properties
      name='Campbell Diagramm'
      modalsystem
   end
   methods
       %Konstruktor
       function obj = Campbell(a)
         if nargin == 0
           disp('Keine Visualierung möglich ohne Modalsystem')
         else
           obj.modalsystem = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
      
            
      function plot(obj)
%           rotorpar=obj.modalsystem.rotorsystem.rotor.cnfg;
          
%           Aev=obj.modalsystem.eigenmatrizen.Aev;
            Aew=obj.modalsystem.eigenmatrizen.Aew;
          n_ew=obj.modalsystem.n_ew;
          
%           nodes=obj.modalsystem.rotorsystem.rotor.nodes;
          omega=obj.modalsystem.omega;
%           EVomega=1;
%           plot_EV_EW(rotorpar,Aev,Aew,nodes,omega,EVomega,n_ew)

%         figure()
%         hold on;
%         plot(omega,omega);
%         for s=1:n_ew
%             a(:)=abs(Aew(1,s,:));
%             b(:)=abs(Aew(2,s,:));
%         plot(omega,a,omega,b)
%         end
        
        plot_campbell(Aew,omega,n_ew)
        
      end
 
 
   end
   methods(Access=private)
       
   end
end