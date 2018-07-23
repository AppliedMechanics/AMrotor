classdef Eigenschwingformen < handle
   properties (Access = private)
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
      
      function plot_displacements(obj)
          
          ColorHandler = AMrotorTools.PlotColors();
          
          n_ew=obj.modalsystem.n_ew;
          ColorHandler.setUp(n_ew);
          %
          disp('Eigenkreisfrequenzen')
            for s=1:n_ew
                disp(' ')
                disp([num2str(s),'. Eigenfrequenz'])
                displayFrequencies('x',obj.modalsystem.eigenValues.x,s)
                displayFrequencies('y',obj.modalsystem.eigenValues.y,s)
            end
          % plotten der Moden
          figure('Name','Eigenschwingformen','NumberTitle','off');
            ax1 = subplot(1,2,1);
            hold on;
            title(ax1,'Eigenmoden x-Richtung')
            ax2 = subplot(1,2,2);
            hold on;
            title(ax2,'y-Richtung')

            x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
        for s=1:n_ew
            plotMode(ax1,x,obj.modalsystem.eigenVectors.x(1:2:end,s),...
                           obj.modalsystem.eigenValues.x(s),...
                           ColorHandler.getColor(s))
            plotMode(ax2,x,obj.modalsystem.eigenVectors.y(1:2:end,s),...
                           obj.modalsystem.eigenValues.y(s),...
                           ColorHandler.getColor(s))
        end
            legend(ax1,'show')
            legend(ax2,'show')
            grid(ax1,'on')
            grid(ax2,'on')
      end
   end
end
