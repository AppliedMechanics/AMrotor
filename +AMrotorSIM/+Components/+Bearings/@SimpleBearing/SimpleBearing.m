% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef SimpleBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleAxialBearing class acts on the x and y direction of the defined node

%   Add stiffness and damping on the x and y degrees of freedom of the
%   closest node of the rotor 
   properties
   end
   methods
        function self=SimpleBearing(arg)
            % Constructor
            %
            %    :parameter arg: Cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: SimpleBearing object
            
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
            self.name = 'Empty Bearing';
            else
            self.cnfg = arg;
            end

        end 
   end
end