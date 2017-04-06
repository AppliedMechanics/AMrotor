classdef Wegsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = "m"
   end
   methods
        function obj=Wegsensor(variable) 
           obj = obj@AMrotorSIM.Sensors.Sensor(variable); 
        end 
        
        function [x_pos,beta_pos,y_pos,alpha_pos] = read_values(obj,rotorsystem)
            z_pos=obj.cnfg.position;
            [x_pos,beta_pos,y_pos,alpha_pos] = displacement_calc_at_pos(z_pos,rotorsystem);
        end
   end
end