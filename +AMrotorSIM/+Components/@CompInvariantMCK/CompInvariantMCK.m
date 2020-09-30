% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef CompInvariantMCK < AMrotorSIM.Components.Component
% CompMatrixInvariant class for pre-assigned mass, damping, stiffness matrices added to one node, invariant i.e. independent of time, rpm, ..
    properties
    end
    methods
        function self = CompInvariantMCK(arg)
            %Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: CompInvariantMCK object
            
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty CompInvariantMCK';
            else
                self.mass_matrix = arg.mass_matrix;
                self.damping_matrix = arg.damping_matrix;
                self.stiffness_matrix = arg.stiffness_matrix;
                if isfield(arg,'gyroscopic_matrix')
                    self.gyroscopic_matrix = arg.gyroscopic_matrix;
                else
                    self.gyroscopic_matrix = sparse(6,6);
                end
            end
        end
    end
end