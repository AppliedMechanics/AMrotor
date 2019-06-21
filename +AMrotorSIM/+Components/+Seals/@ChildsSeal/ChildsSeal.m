classdef ChildsSeal < AMrotorSIM.Components.Seals.Seal
    % calculation of the seal-coefficients according to Black
   properties
   end
   methods
        function self=ChildsSeal(arg)
            self = self@AMrotorSIM.Components.Seals.Seal(arg);
            if nargin == 0
            self.name = 'Empty Childs-Seal';
            end

        end 
   end
end