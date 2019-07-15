classdef (Abstract) Seal < AMrotorSIM.Components.Component
% Seal - superclass for Seals, which are components
% seals that are characterised by mass, damping and stiffness seal
% coefficients
    properties
    end
    methods
        %Konstruktor
        function self = Seal(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Seal';
            end
            self.color = 'red';
        end
        
    end
    
end