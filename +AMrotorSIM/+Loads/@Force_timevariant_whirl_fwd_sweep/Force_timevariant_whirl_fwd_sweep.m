classdef Force_timevariant_whirl_fwd_sweep < AMrotorSIM.Loads.Load
% Class of forward whirl with linearly increasing or decreasing frequency and constant amplitude and direction

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
   end
   methods
        function obj=Force_timevariant_whirl_fwd_sweep(variable)
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_timevariant_whirl_fwd_sweep
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end