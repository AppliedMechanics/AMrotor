classdef LookUpTableSeal < AMrotorSIM.Seals.Seal
   properties
       cnfg
       integrationProblemFlag = true;
   end
   methods
        function self=LookUpTableSeal(arg)
            self = self@AMrotorSIM.Seals.Seal(arg);
            if nargin == 0
            self.name = 'Empty Seal';
            else
            self.cnfg = arg;
            self.color = 'red';
            end
            if isfield(arg,'integrationProblemFlag')
             self.integrationProblemFlag = arg.integrationProblemFlag;
            end
        end 
   end
end