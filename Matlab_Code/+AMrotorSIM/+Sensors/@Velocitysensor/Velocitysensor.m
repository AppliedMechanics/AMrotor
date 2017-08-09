classdef Velocitysensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm/s'
       Position
       measurementType = 'Velocity'  
   end
   methods
        function self=Velocitysensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
           self.Position = config.position;
        end 
        
        function [x_val,y_val] = read_velocity_values(obj,rotorsystem)
            [x_val,y_val] = velocity_calc_at_pos(obj.cnfg.position,rotorsystem);
        end
   end
end


