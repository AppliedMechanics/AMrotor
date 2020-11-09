classdef BlackSeal < AMrotorSIM.Components.Seals.Seal
% Class for seals of type Black (BlackSeal)

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
   end
   methods
        function self=BlackSeal(arg)
            % Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: BlackSeal object
            
            self = self@AMrotorSIM.Components.Seals.Seal(arg);
            if nargin == 0
            self.name = 'Empty Black-Seal';
            end

        end 
   end
end