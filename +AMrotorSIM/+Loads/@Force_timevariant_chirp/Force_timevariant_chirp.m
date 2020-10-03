% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Force_timevariant_chirp < AMrotorSIM.Loads.Load
% Class of force-chirp with increasing or decreasing excitation frequency and constant amplitude and direction

   properties
   end
   methods
        function obj=Force_timevariant_chirp(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Force_timevariant_chirp object
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end