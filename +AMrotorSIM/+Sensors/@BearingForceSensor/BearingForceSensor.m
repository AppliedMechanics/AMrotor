classdef BearingForceSensor < AMrotorSIM.Sensors.Sensor
% BearingForceSensor Class of sensors for the forces of objects of the
% Bearing-class
%   reads the force acting ON the rotor:
%   F = - (k*x +d*x_dot)
% See also AMrotorSIM.Components.Bearings
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