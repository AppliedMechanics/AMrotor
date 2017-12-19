classdef Waterfalldiagramm < handle
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung  --- '
    abtastrate
    drehzahl
    timeresults
    experiment
   end
  methods
  function self=Waterfalldiagramm(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
  end
  
  function plot(self,sensors)
      disp(self.name)
             j = 1;
             F_x={}; Y_x={}; AMPL_x={};
             F_y={}; Y_y={}; AMPL_y={};
             Drehzahl = {}; DZ = [];
      
       for sensor = sensors
          
          [x_val,~,y_val,~]=sensor.read_sensor_values(self.experiment);
          for rpm = self.experiment.drehzahlen            
            fs = self.abtastrate;
            [f_x,y_x,ampl_x] = FFT_Data_Gesamt (x_val(rpm),fs);                    
            F_x{j,1}= f_x;
            Y_x{j,1}= y_x;
            AMPL_x{j,1}= ampl_x;

            [f_y,y_y,ampl_y] = FFT_Data_Gesamt (y_val(rpm),fs);                    
            F_y{j,1}= f_y;
            Y_y{j,1}= y_y;
            AMPL_y{j,1}= ampl_y;

            DZ(1,1:size(f_y,2))=self.experiment.drehzahlen(j);

            Drehzahl{j,1}= DZ;
            j = j+1;
          end 
          % Umformatierung
         F_x= cell2mat(F_x);
         Y_x= cell2mat(Y_x);
         AMPL_x= cell2mat(AMPL_x);               
                
         F_y= cell2mat(F_y);
         Y_y= cell2mat(Y_y);
         AMPL_y = cell2mat(AMPL_y);
         Drehzahl = cell2mat(Drehzahl);
        % Plot        
         figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Waterfall'], 'NumberTitle', 'off');  
         subplot(2,1,1)
             mesh(Drehzahl,F_x,AMPL_x)
             ylim([0,150]);
             xlabel('Drehzahl [U/min]')
             ylabel('Frequenz [Hz]')
             ylim([0 150]);
             zlabel(['Amplitude [', sensor.unit,']'])
             title ('Waterfalldiagramm of x-values')
         subplot (2,1,2)
             mesh(Drehzahl,F_y,AMPL_y)
             ylim([0,150]);
             xlabel('Drehzahl [U/min]')
             ylabel('Frequenz [Hz]')
             ylim([0 150]);
             zlabel(['Amplitude [', sensor.unit,']'])
             title ('Waterfalldiagramm of y-values')
 
       end
       
     end
      
   end
      
end



