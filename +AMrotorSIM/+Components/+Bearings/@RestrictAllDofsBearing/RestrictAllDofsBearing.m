% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef RestrictAllDofsBearing < AMrotorSIM.Components.Bearings.Bearing
% RestrictAllDofsBearing class to restrict all DOFs at a defined node
            
%   Add stiffness and damping on every degree of freedom of the closest
%   node of the rotor
    properties
    end
    methods
        function self=RestrictAllDofsBearing(arg)
            %Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: RestrictAllDofsBearing object
            
            self = self@AMrotorSIM.Components.Bearings.Bearing(arg);
            if nargin == 0
                self.name = 'Empty Bearing';
            end
            
        end
    end
end