classdef Frequenzgangfunktion < handle
% FREQUENZGANGFUNKTION Class for calculation of frequency response fúnctions
%     This class calculates the frequency response function between
%     specified points, for a specidifed frequency vector using the
%     AbraVibe toolbox
    properties
        name
        rotorsystem
        f
        H
        type
        inputPosition
        outputPosition
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