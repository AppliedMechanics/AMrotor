classdef Velocitysensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for reading the velocity values at the node after time integration

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
       unit = 'm/s'
       measurementType = 'Velocity'  
   end
   methods
        function self=Velocitysensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: Velocitysensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config);
        end 
   end
end


