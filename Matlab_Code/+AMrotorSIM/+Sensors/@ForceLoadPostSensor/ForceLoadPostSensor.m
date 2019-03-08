classdef ForceLoadPostSensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'N'
       Position
       measurementType = 'Force'
   end
   methods
        function self=ForceLoadPostSensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
   end
end