classdef Unbalance_static < AMrotorSIM.Loads.Load
% Class for unbalance on the rotor

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties

   end
   methods
        function obj=Unbalance_static(variable) 
            % Constructor
            %
            %    :parameter variable: cnfg_load substruct of cnfg-struct
            %    :type variable: struct
            %    :return: Unbalance_static object
            
           obj = obj@AMrotorSIM.Loads.Load(variable); 
        end 
        
   end
end