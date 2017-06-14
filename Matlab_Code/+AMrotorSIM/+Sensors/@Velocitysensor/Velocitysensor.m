classdef Velocitysensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm/s'
       Position
   end
   methods
        function self=Velocitysensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
           self.Position = config.position;
        end 
        
        function [v_x,v_y] = read_values(obj,rotorsystem)
            [v_x,v_y] = velocity_calc_at_pos(obj.cnfg.position,rotorsystem);
        end
   end
end


