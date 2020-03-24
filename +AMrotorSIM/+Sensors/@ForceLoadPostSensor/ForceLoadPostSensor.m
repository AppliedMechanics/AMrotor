classdef ForceLoadPostSensor < AMrotorSIM.Sensors.Sensor
% ForceLoadPostSensor Class of sensors for the forces of objects of the
% LOADS-class
%   only givess the forces of the loads that are defined as objects of the
%   Loads-superclass
   properties
       unit = 'N'
       measurementType = 'Force'
   end
   methods
        function self=ForceLoadPostSensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
        end 
   end
end