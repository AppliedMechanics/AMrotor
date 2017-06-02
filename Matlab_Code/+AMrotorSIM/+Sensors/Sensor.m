classdef Sensor < matlab.mixin.Heterogeneous & handle
   properties
      cnfg=struct([])  
      name
   end
   methods
      %Konstruktor
       function obj = Sensor(arg)
         if nargin == 0
           obj.name = 'Depp';
         else
           obj.cnfg = arg;
           obj.name = obj.cnfg.name;
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
   end
end