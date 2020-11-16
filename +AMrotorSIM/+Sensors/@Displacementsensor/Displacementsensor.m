classdef Displacementsensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for reading the displacement values after time integration

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
       unit = 'm'
       measurementType = 'Distance'
   end
   methods
        function self=Displacementsensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: Displacementsensor object 
            
           self = self@AMrotorSIM.Sensors.Sensor(config); 
        end 
   end
end