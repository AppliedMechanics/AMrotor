classdef Wegsensor < Sensor
   properties
       unit = "m"
   end
   methods
        function obj=Wegsensor(variable) 
           obj = obj@Sensor(variable); 
        end 
   end
end