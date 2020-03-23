classdef Frequenzgangfunktion < handle
% FREQUENZGANGFUNKTION Class for calculation of frequency response functions
%     This class calculates the frequency response function between
%     specified points, for a specidifed frequency vector using the
%     AbraVibe toolbox
% See also AMrotorSIM.Graphs.Frequenzgangfunktion
    
    properties
        name
        % See also AMrotorSIM.Rotorsystem
        rotorsystem (1,1) AMrotorSIM.Rotorsystem
        f % frequency array: nFreq x 1
        H % matrix of frfs: nFreq x nResponses x nInputForces
        descriptionsH % description of entries in H for plot, cells
        type % type of frf: acceleration 'a', velocity 'v', displacement 'd'
        unit
        inputPosition   % position of the inputs/InputForces
        outputPosition  % position of the outputs
    end
    methods
        % Konstruktor
        function self = Frequenzgangfunktion(rotorsystem,name)
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