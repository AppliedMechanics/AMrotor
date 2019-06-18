classdef BlackSeal < AMrotorSIM.Seals.Seal
    % calculation of the seal-coefficients according to Black
   properties
       cnfg
   end
   methods
        function self=BlackSeal(arg)
            self = self@AMrotorSIM.Seals.Seal(arg);
            if nargin == 0
            self.name = 'Empty Seal';
            else
            self.cnfg = arg;
            self.color = 'red';
            end

        end 
   end
end