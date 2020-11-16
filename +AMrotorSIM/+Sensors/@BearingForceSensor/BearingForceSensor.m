% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef BearingForceSensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for reading the forces acting on the rotor from Bearing-class objects
%
% See also AMrotorSIM.Components.Bearings

%   reads the force acting ON the rotor:
%   F = - (k*x +d*x_dot)
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
       unit = 'N'
       measurementType = 'Force'
   end
   methods
        function self=BearingForceSensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: BearingForceSensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config); 
        end 
   end
end