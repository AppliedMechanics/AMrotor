classdef Velocitysensor < AMrotorSIM.Sensors.Sensor
% Velocitysensor Class of sensors for reading the velocity values after
% time integration
   properties
       unit = 'm/s'
       measurementType = 'Velocity'  
   end
   methods
        function self=Velocitysensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
        end 
   end
end


