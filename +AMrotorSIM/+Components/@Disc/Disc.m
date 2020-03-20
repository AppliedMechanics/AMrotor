classdef Disc < AMrotorSIM.Components.Component
% Disc class for disc component
%   discs only act on the mass matrix
    properties
        radius
        width
    end
    methods
        %Konstruktor
        function self = Disc(arg)
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Disc';
            else
                self.radius = arg.radius;
                self.width = arg.width;
            end
            self.color='yellow';
        end
    end
end