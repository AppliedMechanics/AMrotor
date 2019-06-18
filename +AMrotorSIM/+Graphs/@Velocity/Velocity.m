classdef Velocity < AMrotorSIM.Graphs.Geschwindigkeit
   properties
    unit = 'm'
   end
   methods
      function self=Velocity(variable) 
           self = self@AMrotorSIM.Graphs.Geschwindigkeit(variable); 
      end
      
      function plot(self,sensors)
      disp(' ---   Plot Velocity   ---')
      
          for sensor = sensors
              
           [v_x,v_y]=sensor.read_velocity_values(self.rotorsystem);
              
            figure ('name',[sensor.name, ' at position ',num2str(sensor.Position)], 'NumberTitle', 'off');
            subplot (2,1,1);
            plot(v_x);
            xlabel ('Timestep');
            ylabel ('m/s');
            title('velocity in x');
            subplot (2,1,2);
            plot(v_y);
            xlabel ('Timestep');
            ylabel ('m/s');
            title('velocity in y');
            hold on;
            %title(sensor.name);
            axis equal;
          end
      end
      
   end
end

