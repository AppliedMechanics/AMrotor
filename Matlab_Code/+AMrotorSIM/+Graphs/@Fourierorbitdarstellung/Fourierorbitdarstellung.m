classdef Fourierorbitdarstellung < handle
  
 properties
    unit
    rotorsystem
    name=' ---  Fourierorbitdarstellung  --- '
    time
    drehzahl
 end
   
 methods
    
     function self=Fourierorbitdarstellung(a, time, drehzahl) 
          self.rotorsystem = a;
          self.time = time;
          self.drehzahl = drehzahl;
     end
     

     function plot(self,sensors,Ordnung)
      disp(self.name)
      
          for sensor = sensors
            
            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);
            [x_four] = FourierFit(self.time,x_val,self.drehzahl, Ordnung);
            [y_four] = FourierFit(self.time,y_val,self.drehzahl, Ordnung);

              
            figure%('name',[sensor.name, ' at position ',num2str(sensor.Position),'; Fourierorbit'], 'NumberTitle', 'off');
            plot(x_four, y_four);
            %xlabel([sensor.measurementType,' in x [', sensor.unit, ']']);
            %ylabel([sensor.measurementType,' in y [', sensor.unit, ']']);
            %title([sensor.measurementType, ' in Fourierorbitdarstellung']);

          end
      end
     
 end
    
end

