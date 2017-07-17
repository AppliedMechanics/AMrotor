classdef Waterfalldiagramm < handle
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung  --- '
    abtastrate
    drehzahl
   end
  methods
  function self=Waterfalldiagramm(a, time, drehzahl)  
      self.rotorsystem = a;
      self.abtastrate = 1/(time(2)-time(1));
      self.drehzahl = drehzahl;
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);
            fs = self.abtastrate;
            value = {[x_val], [y_val]};
            j = 1;
%            F_x=zeros(1,length(self.drehzahl)); Y_x=zeros(1,length(self.drehzahl)); AMPL_x=zeros(1,length(self.drehzahl));
%            F_y=zeros(1,length(self.drehzahl)); Y_y=zeros(1,length(self.drehzahl)); AMPL_y=zeros(1,length(self.drehzahl));
             F_x={}; Y_x={}; AMPL_x={};
             F_y={}; Y_y={}; AMPL_y={};
             Drehzahl = {}; DZ = [];
                for drehzahl = self.drehzahl
                    
                    
                    [f_x,y_x,ampl_x] = FFT_Data_Gesamt (x_val,fs);                    
                    F_x{j,1}= f_x;
                    Y_x{j,1}= y_x;
                    AMPL_x{j,1}= ampl_x;
                    
                    [f_y,y_y,ampl_y] = FFT_Data_Gesamt (y_val,fs);                    
                    F_y{j,1}= f_y;
                    Y_y{j,1}= y_y;
                    AMPL_y{j,1}= ampl_y;
                    
                    %DZ(1,1)= self.drehzahl(j);
                    DZ(1,1:size(f_y,2))=self.drehzahl(j);
                    
                    Drehzahl{j,1}= DZ;
                    j = j+1;
                end   
                F_x= cell2mat(F_x);
                Y_x= cell2mat(Y_x);
                AMPL_x= cell2mat(AMPL_x);               
                
                F_y= cell2mat(F_y);
                Y_y= cell2mat(Y_y);
                AMPL_y = cell2mat(AMPL_y);
                Drehzahl = cell2mat(Drehzahl);
                

                mesh(Drehzahl,F_x,AMPL_x)
                %xlabel('Frequency [Hz]');
                %ylabel('Amplitude');
                %if j == 1
                 %   title ('Fourierrepresentation of the values in x');
                %else
                 %   title ('Fourierrepresentation of the values in y');
                %end
                
          end
      end
      
   end
      
end



