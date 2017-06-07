classdef Sensor < matlab.mixin.Heterogeneous & handle
   properties
      cnfg=struct([])  
      name
      type
      
   end
   methods
      %Konstruktor
       function self = Sensor(config)
         if nargin == 0
           self.name = 'Depp';
         else
           assert(isscalar(config));
           self.cnfg = config;
           self.name = self.cnfg.name;
           self.type = self.cnfg.type;
         end
      end
      
      function print(self)
         disp(self.name);
      end
   end
   
end