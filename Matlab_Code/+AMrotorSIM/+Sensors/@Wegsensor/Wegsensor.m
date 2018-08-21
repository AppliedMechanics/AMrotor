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
   end
end