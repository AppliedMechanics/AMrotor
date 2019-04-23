classdef MuszynskaTurbulentSeal < AMrotorSIM.SealsNonLinear.SealNonLinear
    % calculation of the seal-coefficients according to Black
   properties
       cnfg
   end
   methods
        function self=MuszynskaTurbulentSeal(arg)
            self = self@AMrotorSIM.SealsNonLinear.SealNonLinear(arg);
            if nargin == 0
            self.name = 'Empty NonLinearSeal';
            else
            self.cnfg = arg;
            self.name = self.cnfg.name;
            self.position=self.cnfg.position;
            self.color = 'red';
            end

        end 
   end
end