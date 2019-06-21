classdef CompLUTMCK < AMrotorSIM.Components.Component
    properties
        integrationProblemFlag = true
    end
    methods
        function self=CompLUTMCK(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Component (LookUpTable MCK)';
            end
            self.color = 'red';
            if isfield(arg,'integrationProblemFlag')
                self.integrationProblemFlag = arg.integrationProblemFlag;
            end
        end
    end
end