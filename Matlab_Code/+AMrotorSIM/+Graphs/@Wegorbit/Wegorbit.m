classdef Wegorbit < AMrotorSIM.Graphs.Orbit
   properties
    unit = 'm'
   end
   methods
      function obj=Wegorbit(variable) 
           obj = obj@AMrotorSIM.Graphs.Orbit(variable); 
      end
      
      function plot(obj,sensors)
      disp(' ---   Plot Wegorbit   ---')
      
          for i = sensors
              
           [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(obj.rotorsystem);
              
            figure;
            plot(x_pos,y_pos);
            hold on;
            title(i.name);
            axis equal;
          end
      end
      
   end
end