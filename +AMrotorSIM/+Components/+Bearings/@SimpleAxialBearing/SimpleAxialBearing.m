classdef SimpleAxialBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleAxialBearing acts on axial direction of the corresponding node
%   Add stiffness and damping on the axial degree of freedom (z-direction)
%   of the closest node of the rotor
   properties
   end
   methods
        function self=SimpleAxialBearing(arg)
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
            self.name = 'Empty Bearing';
            else
            self.cnfg = arg;
            self.color = 'green'; 
            end

        end 
   end
end