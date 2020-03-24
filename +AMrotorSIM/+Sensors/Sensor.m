classdef Sensor < matlab.mixin.Heterogeneous & handle
% Sensor Superclass for sensors which read values after time integration
% See also AMrotorSIM.Sensors
   properties
      cnfg=struct([])  
      name
      position % desired Position by the user from config
      positionMesh % real position, nearest mesh node
      % type of the Sensor
      % must be name of any Sensor-subclass 
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
           self.position = self.cnfg.position;
         end
       end
   end
      
   methods(Abstract)
       print(self)
       
      [x_val,beta_pos,y_val,alpha_pos]=read_values(self, experiment) 
   end
   
end