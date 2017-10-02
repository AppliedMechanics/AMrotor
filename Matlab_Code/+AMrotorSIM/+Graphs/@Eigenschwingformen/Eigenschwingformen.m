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
          
            Aev_x=abs(obj.modalsystem.eigenmatrizen.Aev_x);
            Aev_y=abs(obj.modalsystem.eigenmatrizen.Aev_y);

           Aev=obj.modalsystem.eigenmatrizen.Aev;
           Aew=obj.modalsystem.eigenmatrizen.Aew;
          n_ew=obj.modalsystem.n_ew;
          
          nodes=obj.modalsystem.rotorsystem.rotor.nodes;
%          omega=obj.modalsystem.omega;
%          EVomega=1;
          
          plot_EV_EW(Aev,Aew,nodes,n_ew);

             figure()
             ax1 = subplot(1,2,1);
             hold on;
             title(ax1,'Eigenmoden x-Richtung')
             ax2 = subplot(1,2,2);
             hold on;
             title(ax2,'y-Richtung')
         for s=1:n_ew
             plot(ax1,(Aev_x(:,s,1)/norm(Aev_x(:,s,1))))
             plot(ax2,(Aev_y(:,s,1)/norm(Aev_y(:,s,1))))
         end

      end
      
      function plot_displacements(obj)
          
          n_ew=obj.modalsystem.n_ew;
          nodes=obj.modalsystem.rotorsystem.rotor.nodes;
          n_nodes=length(nodes);
          
          V_x = obj.modalsystem.eigenmatrizen.V{1}(:,:,1); %Eigenvektoren
          D_x = obj.modalsystem.eigenmatrizen.D{1}(:,:,1);  % Eigenwerte in Diagonalmatrix
          
          V_y = obj.modalsystem.eigenmatrizen.V{1}(:,:,1);
          D_y = obj.modalsystem.eigenmatrizen.D{1}(:,:,1);
          
          %
          disp('Eigenkreisfrequenzen')

            for s=1:n_ew
            disp(['x: ',num2str((D_x(s,s,1))/(2*pi)),' Hz'])
            disp(['y: ',num2str((D_y(s,s,1))/(2*pi)),' Hz'])
            end
          
          % 
          figure()
            ax1 = subplot(1,2,1);
            hold on;
            title(ax1,'Eigenmoden x-Richtung')
            ax2 = subplot(1,2,2);
            hold on;
            title(ax2,'y-Richtung')

            x = obj.modalsystem.rotorsystem.rotor.nodes;
        for s=1:n_ew
            plot(ax1,x,(real(V_x(:,s,1))/norm(V_x(:,s,1))),'DisplayName',[num2str((D_x(s,s,1))/(2*pi)),' Hz'])
            plot(ax2,x,(real(V_y(:,s,1))/norm(V_y(:,s,1))),'DisplayName',[num2str((D_y(s,s,1))/(2*pi)),' Hz'])
            
        end
            legend(ax1,'show')
            legend(ax2,'show')
      end
   end
end