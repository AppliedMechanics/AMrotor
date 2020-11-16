classdef AngularVelocitysensor < AMrotorSIM.Sensors.Sensor
% Class of sensors for reading the angular velocity values after time integration

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
       unit = 'rad/s'
       measurementType = 'AngularVelocity'  
   end
   methods
        function self=AngularVelocitysensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: AngularVelocitysensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config);
        end 
   end
end


