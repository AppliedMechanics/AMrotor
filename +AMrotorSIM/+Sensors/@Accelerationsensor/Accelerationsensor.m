classdef Accelerationsensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for reading the acceleration values after time integration

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
       unit = 'm/s^2'
       measurementType = 'Acceleration'  
   end
   methods
        function self=Accelerationsensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: Accelerationsensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config);
        end 
   end
end
