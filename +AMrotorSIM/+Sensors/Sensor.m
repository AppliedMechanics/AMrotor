% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Sensor < matlab.mixin.Heterogeneous & handle
% Superclass (abstract) for sensors 

%which read values after time integration
% See also AMrotorSIM.Sensors
   properties
      cnfg=struct([])  
      name
      position 
      positionMesh 
      type 
      
   end
   methods
       function self = Sensor(config)
            % Constructor
            
         if nargin == 0
           self.name = 'Sensor';
         else
           assert(isscalar(config));
           self.cnfg = config;
           self.name = self.cnfg.name;
           self.type = self.cnfg.type;
           self.position = self.cnfg.position;
         end
       end
   end
      
   methods(Abstract)
       print(self)
       
      [x_val,beta_pos,y_val,alpha_pos]=read_values(self, experiment) 
   end
   
end