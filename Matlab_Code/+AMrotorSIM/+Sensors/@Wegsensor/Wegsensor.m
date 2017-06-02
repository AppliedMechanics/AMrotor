classdef Wegsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm'
   end
   methods
        function obj=Wegsensor(config) 
           obj = obj@AMrotorSIM.Sensors.Sensor(config); 
        end 
        
        function [x_pos,beta_pos,y_pos,alpha_pos] = read_values(obj,rotorsystem)
            [x_pos,beta_pos,y_pos,alpha_pos] = ...
                displacement_calc_at_pos(obj.cnfg.position, rotorsystem);
        end
   end
end