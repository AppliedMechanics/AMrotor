classdef TimeDataOutput < handle
% TimeDataOutput class for writing results (from sensors) of time integration in file
%
% See also SAVE_DATA, COMPOSE_DATA, COMPOSE_DATA_SENSOR_WISE, CONVERT_DATA_TO_STRUCT_SENSOR_WISE

%   Extracts the result data from the time integration of particular nodes;
%   These nodes correspond to Sensor positions 
%   Results are written in the form of a container and saved to a file on
%   the hard drive
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file
 
    properties
        rotorsystem
        experiment_result
        experiment
        dataset
    end
    
    methods
        function self= TimeDataOutput(experiment)  
            % Constructor
            %
            %    :parameter experiment: Object of class Experiment
            %    :type experiment: object
            %    :return: TimeDataOutput object
            
            self.experiment = experiment;
            self.rotorsystem = experiment.rotorsystem;
            self.experiment_result = experiment.result;
       end
        
    end
    
end
