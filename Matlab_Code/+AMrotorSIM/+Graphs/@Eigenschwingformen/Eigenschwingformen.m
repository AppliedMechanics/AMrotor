classdef Eigenschwingformen < handle
   properties
      name='Rotor Eigenschwingformen'
      modalsystem
   end
   methods
       %Konstruktor
       function obj = Eigenschwingformen(a)
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
          
%            Aev_x=abs(obj.modalsystem.eigenmatrizen.Aev_x);
%            Aev_y=abs(obj.modalsystem.eigenmatrizen.Aev_y);

           Aev=obj.modalsystem.eigenmatrizen.Aev;
           Aew=obj.modalsystem.eigenmatrizen.Aew;
          n_ew=obj.modalsystem.n_ew;
          
          nodes=obj.modalsystem.rotorsystem.rotor.nodes;
%          omega=obj.modalsystem.omega;
%          EVomega=1;
          
          plot_EV_EW(Aev,Aew,nodes,n_ew);

%             figure()
%             ax1 = subplot(1,2,1);
%             hold on;
%             title(ax1,'Eigenmoden x-Richtung')
%             ax2 = subplot(1,2,2);
%             hold on;
%             title(ax2,'y-Richtung')
%         for s=1:n_ew
%             plot(ax1,(Aev_x(:,s,1)/norm(Aev_x(:,s,1))))
%             plot(ax2,(Aev_y(:,s,1)/norm(Aev_y(:,s,1))))
%         end

      end
 
   end
   methods(Access=private)
       
   end
end