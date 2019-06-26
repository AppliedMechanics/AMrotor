classdef RestrictAllDofsBearing < AMrotorSIM.Components.Bearings.Bearing
% RestrictAllDofsBearing acts on all dofs of the corresponding node
%   Add stiffness and damping on every degree of freedom of the closest
%   node of the rotor
    properties
    end
    methods
        function self=RestrictAllDofsBearing(arg)
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            
        end
    end
end