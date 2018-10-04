function plot_Orbit(self,sensors)
  disp(' --- Plot Graph Orbit  --- ')

      for sensor = sensors

        [x_val,~,y_val,~]=...
            sensor.read_values(self.experiment);

        figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Orbit'], 'NumberTitle', 'off');

        tmp.count = 1;
        for rpm = self.experiment.drehzahlen
            plot(x_val(rpm),y_val(rpm),...
                'Color',self.ColorHandler.getColor(tmp.count),...
                'DisplayName',sprintf('%1.0f 1/min',rpm));
            xlabel(['x in ' sensor.unit]);
            ylabel(['y in ' sensor.unit]);
            % increment counter
            tmp.count = tmp.count + 1;
        end
      end
end