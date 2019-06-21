classdef Disc < AMrotorSIM.Components.Component
    properties
        radius
    end
    methods
        %Konstruktor
        function self = Disc(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Disc';
            else
                self.radius = arg.radius;
            end
            self.color='yellow';
        end
    end
end