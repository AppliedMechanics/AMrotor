classdef TimeSignal < handle
   properties
    unit='m'
    rotorsystem
    name=' ---  Zeitsignale  --- '
   end
  methods
  function obj=TimeSignal(a) 
      obj.rotorsystem = a;
  end
  
  function plot(obj,sensors)
      disp(obj.name)
      
          for i = sensors
              
           [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(obj.rotorsystem);
              
            figure;
            plot(x_pos);
            hold on;
            plot(y_pos);
            legend('X-Richtung','Y-Richtung');
            title(i.name);
          end
      end
      
   end
      
end