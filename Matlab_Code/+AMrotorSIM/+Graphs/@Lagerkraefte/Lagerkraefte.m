classdef Lagerkraefte < AMrotorSIM.Graphs.Kraefte
   properties
    unit = 'N'
   end
   methods
      function self=Lagerkraefte(config) 
           self = self@AMrotorSIM.Graphs.Kraefte(config); 
      end
      
      function plot(obj,sensors)
      disp(' ---   Plot forces at sensor position   ---')
      
          for sensor = sensors
              
           [f_x, f_y, f_z] = sensor.measure_force(obj.rotorsystem);
              
            figure;
            subplot(3,1,1);
            plot(f_x);
            xlabel ('Timestep')
            ylabel ('N')
            title('Force in x');
            
            subplot(3,1,2);
            plot(f_y);
            xlabel ('Timestep')
            ylabel ('N')
            title('Force in y');
            
            subplot(3,1,3);
            plot(f_z);
            xlabel ('Timestep')
            ylabel ('N')
            title('Force in z'); 
            hold on;
            
            title(sensor.name);
            axis equal;
          end
      end
      
   end
end

