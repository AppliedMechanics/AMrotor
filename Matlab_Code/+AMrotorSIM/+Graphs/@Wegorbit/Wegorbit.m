classdef Wegorbit < AMrotorSIM.Graphs.Orbit
   properties
    unit = 'm'
   end
   methods
      function obj=Wegorbit(variable) 
           obj = obj@AMrotorSIM.Graphs.Orbit(variable); 
      end
      
      function plot(self,sensors)
      disp(' ---   Plot Wegorbit   ---')
      
          for i = sensors
              
           [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(self.rotorsystem);
            drehzahlen=cell2mat(keys(self.rotorsystem.time_result));
            
            for drehzahl = drehzahlen
            figure;
            plot(x_pos(drehzahl),y_pos(drehzahl));
            hold on;
            end
            title(i.name);
            axis equal;
          end
      end
      
   end
end