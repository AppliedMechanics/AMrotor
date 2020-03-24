function plot(self,sensors)
% main method for the user
% plot(self,sensors,direction)
  disp(self.name)

      for sensor = sensors
          
        [x_val,y_val,~]=sensor.read_values(self.experiment);


        figure('name',[sensor.name, ' at position ',num2str(sensor.position),...
            '(mesh node ', num2str(sensor.positionMesh),'); Orbit'],...
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