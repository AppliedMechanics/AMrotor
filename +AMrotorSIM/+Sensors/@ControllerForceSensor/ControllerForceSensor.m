% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef ControllerForceSensor < AMrotorSIM.Sensors.Sensor
% Class of sensor for reading the forces for the controller at the AMB's

   properties
       unit = 'N'
       measurementType = 'Force'
   end
   methods
        function self=ControllerForceSensor(cnfg) 
            % Constructor
            %
            %    :parameter config: Cnfg_component substruct of cnfg-struct
            %    :type config: struct
            %    :return: ControllerForceSensor object
            
           self = self@AMrotorSIM.Sensors.Sensor(cnfg); 
        end 
   end
end