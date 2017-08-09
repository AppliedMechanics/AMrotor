classdef Wegsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm'
       Position
       measurementType = 'Distance'
   end
   methods
        function self=Wegsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
        
        function [x_val,beta_pos,y_val,alpha_pos] = read_values(obj,rotorsystem)
            [x_val,beta_pos,y_val,alpha_pos] = ...
                displacement_calc_at_pos(obj.cnfg.position, rotorsystem);
        end
   end
end