classdef SimpleSeal < AMrotorSIM.Seals.Seal
   properties
       cnfg
   end
   methods
        function self=SimpleSeal(arg)
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