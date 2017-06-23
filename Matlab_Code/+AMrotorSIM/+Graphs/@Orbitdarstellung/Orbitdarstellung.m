classdef Orbitdarstellung < handle
   properties
    unit
    rotorsystem
    name=' ---  Orbitdarstellung  --- '
   end
  methods
  function self=Orbitdarstellung(a) 
      self.rotorsystem = a;
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);

              
            figure('name',[sensor.name, ' at position ',num2str(sensor.Position),'; Orbit'], 'NumberTitle', 'off');
            plot(x_val, y_val);
            xlabel([sensor.measurementType,' in x [', sensor.unit, ']']);
            ylabel([sensor.measurementType,' in y [', sensor.unit, ']']);
            title([sensor.measurementType, ' in orbitdarstellung']);

          end
      end
      
   end
      
end