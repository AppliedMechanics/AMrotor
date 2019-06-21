classdef (Abstract) Seal < AMrotorSIM.Components.Component
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