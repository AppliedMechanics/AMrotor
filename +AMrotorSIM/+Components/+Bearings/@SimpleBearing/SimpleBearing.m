classdef SimpleBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleBearing acts on the x and y direction of the corresponding node

%   Add stiffness and damping on the x and y degrees of freedom of the
%   closest node of the rotor 
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
   end
   methods
        function self=SimpleBearing(arg)
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
            self.name = 'Empty Bearing';
            else
            self.cnfg = arg;
            end

        end 
   end
end