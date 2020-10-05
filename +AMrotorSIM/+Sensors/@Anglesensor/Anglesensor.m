% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Anglesensor < AMrotorSIM.Sensors.Sensor
% Class of sensors for reading the angle values after time integration
   properties
       unit = 'rad'
       measurementType = 'Angle'
   end
   methods
        function self=Anglesensor(config) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: Anglesensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(config); 
        end 
   end
end