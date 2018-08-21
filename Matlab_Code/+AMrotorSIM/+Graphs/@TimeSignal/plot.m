function plot(self,sensors)
  disp(' --- Plot Graph Timesignal  --- ')

      for sensor = sensors

        [x_val,~,y_val,~]=...
            sensor.read_sensor_values(self.experiment);

        figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Timesignal'], 'NumberTitle', 'off');

        tmp.count = 1;
        for rpm = self.experiment.drehzahlen
            % subplot 1
            subplot(2,1,1);
                hold on
                plot( self.time,x_val(rpm),...
                            'Color',self.ColorHandler.getColor(tmp.count),...
                            'DisplayName',sprintf('%1.0f 1/min',rpm));
                xlabel('time [s]');
                ylabel(sensor.unit);
                title([sensor.measurementType, ' in x']);
                legend('show');
                hold off
            % subplot 2
            subplot(2,1,2);
                hold on
                plot(self.time, y_val(rpm),...
                            'Color',self.ColorHandler.getColor(tmp.count));
                xlabel('time [s]');
                ylabel(sensor.unit);
                title([sensor.measurementType, ' in y']);
                hold off
            % increment counter
            tmp.count = tmp.count + 1;
        end
      end
end