classdef Accelerationsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm/s^2'
       Position
       measurementType = 'Acceleration'  
   end
   methods
        function self=Accelerationsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
           self.Position = config.position;
        end 
        
        function [x_val,y_val] = read_acceleration_values(obj,rotorsystem)
            [x_val,y_val] = acceleration_calc_at_pos(obj.cnfg.position,rotorsystem);
        end
   end
end
