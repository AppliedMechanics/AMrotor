% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef ForceLoadPostSensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for the forces (ForceLoadPost) ????????


   properties
       unit = 'N'
       measurementType = 'Force'
   end
   methods
        function self=ForceLoadPostSensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: ForceLoadPostSensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config); 
        end 
   end
end