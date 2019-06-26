classdef Displacementsensor < AMrotorSIM.Sensors.Sensor
% Displacementsensor Class of sensors for reading the displacement values
% after time integration
   properties
       unit = 'm'
       Position
       measurementType = 'Distance'
   end
   methods
        function self=Displacementsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
   end
end