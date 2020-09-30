% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef (Abstract) Bearing < AMrotorSIM.Components.Component
% Bearing superclass (abstract) for different bearing types

%   Bearings are characterized by stiffness and damping coefficients
% See also AMrotorSIM.Components.Bearings
    properties
    end
    methods
        function self = Bearing(arg)
            % Constructor
            
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
        end
        
    end
    
end