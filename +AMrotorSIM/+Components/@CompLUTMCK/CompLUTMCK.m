classdef CompLUTMCK < AMrotorSIM.Components.Component
% CompLUTMCK class for variable (e.g variable over rpm) mass, damping, stiffness matrices from Look-Up-Table 

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
        integrationProblemFlag = true
    end
    methods
        function self=CompLUTMCK(arg)
            % Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: CompLUTMCK object
            
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