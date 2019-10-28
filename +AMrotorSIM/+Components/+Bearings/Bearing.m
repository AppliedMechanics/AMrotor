classdef (Abstract) Bearing < AMrotorSIM.Components.Component
% Bearing superclass for different bearing types with stiffness and damping
%   Bearings are characterized by stiffness and damping coefficients
% See also AMrotorSIM.Components.Bearings
    properties
    end
    methods
        function self = Bearing(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            self.color = 'green';
        end
        
    end
    
end