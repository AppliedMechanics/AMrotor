classdef Fourierdarstellung < handle
   properties
    unit
    rotorsystem
    name=' ---  Fourierdarstellung  --- '
    abtastrate
   end
  methods
  function self=Fourierdarstellung(a, time)  
      self.rotorsystem = a;
      self.abtastrate = 1/(time(2)-time(1));
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);
            fs = self.abtastrate;
            value = {[x_val], [y_val]};
            j = 1;
            figure('name',[sensor.name, ' at position ',num2str(sensor.Position),'; Fourier'], 'NumberTitle', 'off');
            for val = value 
                v = cell2mat(val);
                [f,Y,ampl] = FFT_Data_Gesamt (v,fs);            
                subplot (2,1,j);
                plot(f, ampl);
                xlabel('Frequency [Hz]');
                ylabel('Amplitude');
                if j == 1
                    title ('Fourierrepresentation of the values in x');
                else
                    title ('Fourierrepresentation of the values in y');
                end
                j = j+ 1;
            end
          end
      end
      
   end
      
end

