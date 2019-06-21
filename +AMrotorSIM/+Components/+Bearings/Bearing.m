classdef (Abstract) Bearing < AMrotorSIM.Components.Component
    properties
        stiffness
        damping
    end
    methods
        %Konstruktor
        function self = Bearing(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            self.color = 'green';
        end
        
    end
    
end