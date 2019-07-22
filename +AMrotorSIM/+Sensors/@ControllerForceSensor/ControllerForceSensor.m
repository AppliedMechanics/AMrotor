classdef ControllerForceSensor < AMrotorSIM.Sensors.Sensor
% ControllerForceSensor Class of sensors for the forces of objects of the
% LOADS-class
%   only givess the forces of the loads that are defined as objects of teh
%   Loads-superclass
   properties
       unit = 'N'
       Position
       measurementType = 'Force'
   end
   methods
        function self=ControllerForceSensor(cnfg) 
           self = self@AMrotorSIM.Sensors.Sensor(cnfg); 
           self.Position = cnfg.position;
        end 
   end
end