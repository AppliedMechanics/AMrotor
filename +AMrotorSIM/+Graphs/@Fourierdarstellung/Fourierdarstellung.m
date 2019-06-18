classdef Fourierdarstellung < handle
   properties
    unit
    rotorsystem
    name=' ---  Fourierdarstellung  --- '
    abtastrate
    experiment
    ColorHandler
   end
  methods
  function self=Fourierdarstellung(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,~,y_val,~]=sensor.read_values(self.experiment);
            fs = self.abtastrate;
            
            
            figure('name',[sensor.name, ' at position ',num2str(sensor.Position),'; Fourier'], 'NumberTitle', 'off');
            tmp.count = 1;
            for rpm = self.experiment.drehzahlen
                value = {[x_val(rpm)], [y_val(rpm)]};
                j = 1;
                for val = value 
                    v = cell2mat(val);
                    [f,~,ampl] = FFT_Data_Gesamt (v,fs);            
                    subplot (2,1,j);
                        hold on
                        plot(f, ampl,...
                             'Color',self.ColorHandler.getColor(tmp.count),...
                             'DisplayName',sprintf('%1.0f 1/min',rpm));
                         hold off
                    legend('show')
                    xlabel('Frequency [Hz]');
                    ylabel('Amplitude');
                    if j == 1
                        title ('Fourierrepresentation of the values in x');
                    else
                        title ('Fourierrepresentation of the values in y');
                    end
                    j = j+ 1;
                end
                tmp.count = tmp.count + 1;
            end
          end
      end
      
   end
      
end

