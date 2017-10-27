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
      
      function plot_displacements(obj)
          
          n_ew=obj.modalsystem.n_ew;
          
          [V.x,D.x] = getEigenform( obj, n_ew, 'x' );
          [V.y,D.y] = getEigenform( obj, n_ew, 'y' );          
          %
          disp('Eigenkreisfrequenzen')
            for s=1:n_ew
                disp(' ')
                disp([num2str(s),'. Eigenfrequenz'])
                displayFrequencies('x',D.x,s)
                displayFrequencies('y',D.y,s)
            end
          % plotten der Moden
          figure('Name','Eigenschwingformen','NumberTitle','off');
            ax1 = subplot(1,2,1);
            hold on;
            title(ax1,'Eigenmoden x-Richtung')
            ax2 = subplot(1,2,2);
            hold on;
            title(ax2,'y-Richtung')

            x = obj.modalsystem.rotorsystem.rotor.nodes;
        for s=1:n_ew
            plotMode(ax1,x,V.x(1:2:end,s),D.x(s))
            plotMode(ax2,x,V.y(1:2:end,s),D.y(s))
        end
            legend(ax1,'show')
            legend(ax2,'show')
            grid(ax1,'on')
            grid(ax2,'on')
      end
   end
end
