classdef FrequenzgangfunktionTime < handle
% FREQUENZGANGFUNKTIONTIME Class for calculation of frequency response
% functions from time signals
%     This class calculates the frequency response function between
%     specified sensors using he abravibe toolbox
%     Just für SISO: First step, maybe later expansion to MIMO
% See also AMrotorSIM.Graphs.Frequenzgangfunktion
% AMrotorSIM.Experiments.Stationaere_Lsg
    properties
        name
        % See also AMrotorSIM.Experiments
        experiment
        f % frequency array: nFreq x 1
        H % matrix of frfs: nFreq x nResponses x nInputForces
        C % Coherence of frf
%         Cx % Coherence between inputs, maybe later for MIMO
        % Input sensor
        % See also AMrotorSIM.Sensors
        sensorIn
        % Output sensor
        % See also AMrotorSIM.Sensors
        sensorOut
        descriptionsH % description of entries in H for plot, cells
        type % type of frf: acceleration 'a', velocity 'v', displacement 'd'
        unit
        inputDirection
        outputDirection
%         inputPosition   % position of the inputs/InputForces
%         outputPosition  % position of the outputs
    end
    methods
        % Konstruktor
        function self = FrequenzgangfunktionTime(experiment,name)
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