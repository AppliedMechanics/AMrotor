classdef FrequenzgangfunktionTime < handle
% Class for calculation of frequency response functions from time signals
%
% See also AMrotorSIM.Graphs.Frequenzgangfunktion,AMrotorSIM.Experiments.Stationaere_Lsg

%     This class calculates the frequency response function between
%     specified sensors using he abravibe toolbox
%     Just für SISO: First step, maybe later expansion to MIMO
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file


    properties
        name
        experiment
        f; % frequency array nFreq x 1
        H; % matrix of frf's: nFreq x nResponses x nInputForce
        C
        sensorIn
        sensorOut
        descriptionsH; % description of entries in H for plot, cells
        type; % acceleration 'a', velocity 'v', displacement 'd'
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