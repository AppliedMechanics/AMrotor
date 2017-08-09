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
      
      function [x_val,beta_pos,y_val,alpha_pos] = read_sensor_values( sensor, rotorsystem )
        switch sensor.type
            case 1
                [x_val,beta_pos,y_val,alpha_pos]= sensor.read_values(rotorsystem);
            case 2
                [x_val,y_val]= sensor.measure_force(rotorsystem);
                beta_pos = NaN;
                alpha_pos = NaN;
            case 3
                [x_val,y_val]=sensor.read_velocity_values(rotorsystem);
                beta_pos = NaN;
                alpha_pos = NaN;
            case 4
                [x_val,y_val]=sensor.read_acceleration_values(rotorsystem);
                beta_pos = NaN;
                alpha_pos = NaN;
        end

       end
   end
   
end