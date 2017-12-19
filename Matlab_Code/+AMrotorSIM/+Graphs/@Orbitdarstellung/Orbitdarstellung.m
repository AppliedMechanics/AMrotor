classdef Orbitdarstellung < handle
   properties
    unit
    rotorsystem
    name=' ---  Orbitdarstellung  --- '
    experiment
    ColorHandler
   end
  methods
  function self=Orbitdarstellung(a, experiment) 
      self.rotorsystem = a;
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.setUp(length(experiment.drehzahlen));
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,~,y_val,~]=sensor.read_sensor_values(self.experiment);

              
            figure('name',[sensor.name, ' at position ',num2str(sensor.Position),'; Orbit'],...
                    'NumberTitle', 'off');
            
            tmp.count = 1;
            for rpm = self.experiment.drehzahlen
                hold on
                    plot(x_val(rpm), y_val(rpm),...
                         'Color',self.ColorHandler.getColor(tmp.count),...
                         'DisplayName',sprintf('%1.0f 1/min',rpm));
                hold off
                legend('show');
                xlabel([sensor.measurementType,' in x [', sensor.unit, ']']);
                ylabel([sensor.measurementType,' in y [', sensor.unit, ']']);
                title([sensor.measurementType, ' in orbitdarstellung']);
                % increment counter
                tmp.count = tmp.count + 1;
            end

          end
      end
      
   end
      
end