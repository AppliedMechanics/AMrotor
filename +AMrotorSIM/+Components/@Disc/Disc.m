classdef Disc < AMrotorSIM.Components.Component
% Disc class for disc component

%   discs only act on the mass matrix
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
    end
    methods       
        function self = Disc(arg)
            % Constructor
            %
            %    :parameter arg: cnfg_component substruct of cnfg-struct
            %    :type arg: struct
            %    :return: Disc object
            
            self = self@AMrotorSIM.Components.Component(arg);
            if nargin == 0
                self.name = 'Empty Disc';
            end
        end
    end
end