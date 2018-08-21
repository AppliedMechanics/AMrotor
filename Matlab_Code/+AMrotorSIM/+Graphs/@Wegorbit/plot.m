function plot(self,sensors)
      disp(' ---   Plot Wegorbit   ---')
      
          for sensor = sensors
              
           [x_pos,~,y_pos,~]=sensor.read_values(self.rotorsystem);
            drehzahlen=cell2mat(keys(self.rotorsystem.time_result));
            
            for drehzahl = drehzahlen
            figure;
            plot(x_pos(drehzahl),y_pos(drehzahl));
            hold on;
            end
            title(sensor.name);
            axis equal;
          end
end