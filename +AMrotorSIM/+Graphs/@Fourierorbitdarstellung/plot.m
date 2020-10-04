% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot(self,sensors,Ordnung)
% Plots of the Fourier orbits
%
%    :param sensors: Time signal of desired sensor (rotorsystem.sensors) 
%    :type sensors: object
%    :param Ordnung: Order of the Fourier fit from 1 to 8
%    :type Ordnung: double
%    :return: Figure of the Fourier orbit

 % main method for the user
% plot(self,sensors,Ordnung)
% Ordnung = order of FourierFit
% This function requires the Matlab curve fitting toolbox.
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,y_val,~]=sensor.read_values(self.experiment);
            tmp.count = 1;
            figure('name',[sensor.name, ' at position ',num2str(sensor.position),... 
                '(mesh node ', num2str(sensor.positionMesh),') Fourierorbit'],...
                'NumberTitle', 'off');
            for rpm = self.experiment.drehzahlen
                [x_four] = FourierFit(self.time,x_val(rpm),rpm, Ordnung);
                [y_four] = FourierFit(self.time,y_val(rpm),rpm, Ordnung);

                hold on
                plot(x_four, y_four,...
                         'Color',self.ColorHandler.getColor(tmp.count),...
                         'DisplayName',sprintf('%1.0f 1/min',rpm));
                hold off
                xlabel([sensor.measurementType,' in x [', sensor.unit, ']']);
                ylabel([sensor.measurementType,' in y [', sensor.unit, ']']);
                title([sensor.measurementType, ' in Fourierorbitdarstellung']);
                legend('show')
                % increment counter
                tmp.count = tmp.count + 1;
            end
          end
      end