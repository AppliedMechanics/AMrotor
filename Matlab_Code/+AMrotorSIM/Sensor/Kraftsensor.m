classdef Kraftsensor < Sensor
   properties
       unit = "N"
   end
   methods
        function obj=Kraftsensor(variable) 
           obj = obj@Sensor(variable); 
        end 
   end
end