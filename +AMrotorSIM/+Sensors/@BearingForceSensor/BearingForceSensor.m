classdef BearingForceSensor < AMrotorSIM.Sensors.Sensor
% ForceLoadPostSensor Class of sensors for the forces of objects of the
% LOADS-class
%   only givess the forces of the loads that are defined as objects of the
%   Loads-superclass
   properties
       unit = 'N'
       Position
       measurementType = 'Force'
   end
   methods
        function self=BearingForceSensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
   end
end