classdef CompLUTMCK < AMrotorSIM.Components.Component
    properties
    end
    methods
        function self=CompLUTMCK(arg)
            if nargin == 0
                self.name = 'Empty Component (LookUpTable MCK)';
            else
                self.cnfg = arg;
                self.position = arg.position;
            end
            self.color = 'red';
            if isfield(arg,'integrationProblemFlag')
                self.integrationProblemFlag = arg.integrationProblemFlag;
            end
        end
    end
end