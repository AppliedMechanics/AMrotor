% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef SimpleAxialBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleAxialBearing class acts in axial direction on the defined node

%   Add stiffness and damping on the axial degree of freedom (z-direction)
%   of the closest node of the rotor
   properties
   end
   methods
        function self=SimpleAxialBearing(arg)
            % Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: SimpleAxialBearing object
            
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