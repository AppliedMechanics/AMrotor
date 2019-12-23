classdef TimeDataOutput < handle
% TimeDataOutput Class for writing results of time integration in file
%   Extracts the result data from the time integration of particular nodes;
%   These nodes correspond to Sensor positions 
%   Results are written in the form of a container and saved to a file on
%   the hard drive
%
%   See also SAVE_DATA, COMPOSE_DATA, COMPOSE_DATA_SENSOR_WISE, CONVERT_DATASET_TO_STRUCT_SENSOR_WISE.
    properties
        % See also AMrotorSIM.Rotorsystem
        rotorsystem
        experiment_result
        % See also AMrotorSIM.Experiment
        experiment
        dataset
    end
    
    methods
        function self= TimeDataOutput(experiment)  
            self.experiment = experiment;
            self.rotorsystem = experiment.rotorsystem;
            self.experiment_result = experiment.result;
       end
        
    end
    
end
