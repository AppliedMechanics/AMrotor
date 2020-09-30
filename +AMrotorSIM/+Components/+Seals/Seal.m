% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef (Abstract) Seal < AMrotorSIM.Components.Component
% Seal superclass (abstract) for different seal types

% which are components
% seals that are characterised by mass, damping and stiffness seal
% coefficients
    properties
    end
    methods
        function self = Seal(arg)
            % Constructor
            
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Seal';
            end
            self.color = 'red';
        end
        
    end
    
end