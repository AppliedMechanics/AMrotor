classdef LookUpTableBearing < AMrotorSIM.Bearings.Bearing
   properties
       cnfg
       integrationProblemFlag = true;
   end
   methods
        function self=LookUpTableBearing(arg)
            self = self@AMrotorSIM.Bearings.Bearing(arg);
            if nargin == 0
            self.name = 'Empty Bearing';
            else
            self.cnfg = arg;
            self.color = 'green'; 
            end
            if isfield(arg,'integrationProblemFlag')
             self.integrationProblemFlag = arg.integrationProblemFlag;
            end
        end 
   end
end