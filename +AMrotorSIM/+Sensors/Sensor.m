classdef Sensor < matlab.mixin.Heterogeneous & handle
% Sensor Class for sensors which read values after rime integration
   properties
      cnfg=struct([])  
      name
      type
      
   end
   methods
      %Konstruktor
       function self = Sensor(config)
         if nargin == 0
           self.name = 'Sensor';
         else
           assert(isscalar(config));
           self.cnfg = config;
           self.name = self.cnfg.name;
           self.type = self.cnfg.type;
         end
       end
   end
      
   methods(Abstract)
       print(self)
       
      [x_val,beta_pos,y_val,alpha_pos]=read_values(self, experiment) 
   end
   
end