classdef BlackSeal < AMrotorSIM.Components.Seals.Seal
    % calculation of the seal-coefficients according to Black
   properties
   end
   methods
        function self=BlackSeal(arg)
            self = self@AMrotorSIM.Components.Seals.Seal(arg);
            if nargin == 0
            self.name = 'Empty Black-Seal';
            end

        end 
   end
end