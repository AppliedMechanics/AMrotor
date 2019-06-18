classdef LimSinghBearing < AMrotorSIM.Loads.Load
   properties
   end
   methods
        function self=LimSinghBearing(arg)
            self = self@AMrotorSIM.Loads.Load(arg);
            if nargin == 0
            self.name = 'Empty Bearing Load';
            else
            self.cnfg = arg;
            self.name = self.cnfg.name;
            self.position=self.cnfg.position;
            end

        end 
   end
end