% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Force_constant_fix < AMrotorSIM.Loads.Load
% Class of force with constant amplitude and direction
   properties
   end
   methods
       
        function obj=Force_constant_fix(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_constant_fix object
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end