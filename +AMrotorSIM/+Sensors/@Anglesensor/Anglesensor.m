classdef Anglesensor < AMrotorSIM.Sensors.Sensor
% Displacementsensor Class of sensors for reading the displacement values
% after time integration
   properties
       unit = 'rad'
       Position
       measurementType = 'Angle'
   end
   methods
        function self=Anglesensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
   end
end