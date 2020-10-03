% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Force_timevariant_whirl_fwd < AMrotorSIM.Loads.Load
% Class of forward whirl with constant frequency, amplitude and direction
   properties
   end
   methods
        function obj=Force_timevariant_whirl_fwd(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_timevariant_whirl_fwd object
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end