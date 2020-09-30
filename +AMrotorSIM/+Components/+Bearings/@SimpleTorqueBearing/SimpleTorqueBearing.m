% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef SimpleTorqueBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleTorqueBearing class acts on torsional direction of the defined node

%   Add stiffness and damping on the torsional degree of freedom (psi_z) of
%   the closest node of the rotor, the stiffness and damping cause a torque
%   around the z-axis of the system
    properties
    end
    methods
        function self=SimpleTorqueBearing(arg)
            % Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: SimpleTorqueBearing object
            
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            
        end
    end
end