classdef SimpleTorqueBearing < AMrotorSIM.Components.Bearings.Bearing
    properties
    end
    methods
        function self=SimpleTorqueBearing(arg)
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            
        end
    end
end