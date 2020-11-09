classdef Force_timevariant_whirl_bwd < AMrotorSIM.Loads.Load
% Class of backward whirl with constant frequency, amplitude and direction

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
   end
   methods
        function obj=Force_timevariant_whirl_bwd(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_timevariant_whirl_bwd object
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end