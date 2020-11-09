classdef Frequenzgangfunktion < handle
% Class for calculation of frequency response functions
%
% See also AMrotorSIM.Graphs.Frequenzgangfunktion

%     This class calculates the frequency response function between
%     specified points, for a specidifed frequency vector using the
%     AbraVibe toolbox
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

    
    properties
        name
        rotorsystem (1,1) AMrotorSIM.Rotorsystem
        f; % frequency array nFreq x 1
        H; % matrix of frf's: nFreq x nResponses x nInputForce
        descriptionsH 
        type; % acceleration 'a', velocity 'v', displacement 'd'
        unit
        inputPosition
        outputPosition
    end
    methods
        function self = Frequenzgangfunktion(rotorsystem,name)
            % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter name: Name for the FRF analysis
            %    :type name: struct
            %    :return: Frequenzgangfunktion object
            if nargin == 0
                self.name = 'Empty FRF';
                warning('rotorsystem is needed for calculation of frequency response function')
            else
                self.name = name;
                self.rotorsystem = rotorsystem;
            end
        end
        
    end

    
end