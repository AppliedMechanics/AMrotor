classdef TimeDataOutput < handle
% TimeDataOutput Class for writing results of time integration in file
%   Writes the result data from the time integration of nodes, that
%   correspond to Sensor positions in a container and can save it to a file
%   on the hard drive
%
%   See also SAVE_DATA, COMPOSE_DATA.
    properties
        rotorsystem
        experiment_result
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
