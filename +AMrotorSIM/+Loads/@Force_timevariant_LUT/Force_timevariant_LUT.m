classdef Force_timevariant_LUT < AMrotorSIM.Loads.Load
% Class of force from Look Up table (LUT)

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
   end
   methods
        function obj=Force_timevariant_LUT(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_timevariant_LUT object
            
           obj = obj@AMrotorSIM.Loads.Load(variable);
        end 
        
   end
end