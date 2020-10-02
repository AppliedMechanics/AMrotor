% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef FrequenzgangfunktionTime < handle
% Class for calculation of frequency response functions from time signals

%     This class calculates the frequency response function between
%     specified sensors using he abravibe toolbox
%     Just für SISO: First step, maybe later expansion to MIMO
%   f... frequency array nFreq x 1
%   H... matrix of frf's: nFreq x nResponses x nInputForce
%   type... acceleration 'a', velocity 'v', displacement 'd'
%   descriptionsH... description of entries in H for plot, cells
% See also AMrotorSIM.Graphs.Frequenzgangfunktion
% AMrotorSIM.Experiments.Stationaere_Lsg

    properties
        name
        experiment
        f 
        H
        C
        sensorIn
        sensorOut
        descriptionsH 
        type 
        unit
        inputDirection
        outputDirection

    end
    methods
       
        function self = FrequenzgangfunktionTime(experiment,name)
            % Constructor
            %
            %    :parameter experiment: Object of type Experiment
            %    :type experiment: object
            %    :parameter name: Name for the FRF analysis
            %    :type name: struct
            %    :return: FrequenzgangfunktionTime object
            
        % self = Frequenzgangfunktion(rotorsystem,name)
            if nargin == 0
                self.name = 'Empty FRF';
                warning('Time data experiment is needed for calculation of frequency response function')
            elseif nargin == 1
                self.name = 'default frf name';
                self.experiment = experiment;
            else
                self.name = name;
                self.experiment = experiment;
            end
        end
        
    end

    
end