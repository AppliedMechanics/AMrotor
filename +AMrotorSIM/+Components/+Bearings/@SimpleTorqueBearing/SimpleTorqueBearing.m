classdef SimpleTorqueBearing < AMrotorSIM.Components.Bearings.Bearing
% SimpleTorqueBearing acts on torsional direction of the corresponding node
%   Add stiffness and damping on the torsional degree of freedom (psi_z) of
%   the closest node of the rotor, the stiffness and damping cause a torque
%   around the z-axis of the system
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