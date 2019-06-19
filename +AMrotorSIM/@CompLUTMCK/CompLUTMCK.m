classdef CompLUTMCK < handle
    properties
        cnfg
        name
        position
        localisation_matrix
        mass_matrix
        stiffness_matrix
        damping_matrix
        color = 'red';
    end
    methods
        function self=CompLUTMCK(arg)
            if nargin == 0
                self.name = 'Empty Component (LookUpTable MCK)';
            else
                self.cnfg = arg;
                self.position = arg.position;
                self.color = 'red';
            end
            if isfield(arg,'integrationProblemFlag')
                self.integrationProblemFlag = arg.integrationProblemFlag;
            end
        end
    end
end