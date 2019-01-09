classdef TimeDataOutput < handle

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
