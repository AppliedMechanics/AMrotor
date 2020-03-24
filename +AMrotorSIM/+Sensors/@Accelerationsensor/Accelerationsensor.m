classdef Accelerationsensor < AMrotorSIM.Sensors.Sensor
% Accelerationsensor Class of sensors for reading the acceleration values
% after time integration
   properties
       unit = 'm/s^2'
       measurementType = 'Acceleration'  
   end
   methods
        function self=Accelerationsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
        end 
   end
end
