classdef WaterfalldiagrammTwoSided < handle
% Class for visualization of the results of the time integration results as two sided Waterfall diagram

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
    unit
    rotorsystem
    name=' ---  Two Sided Waterfalldiagram  --- '
    abtastrate; % sampling rate
    drehzahl; % rotation speed
    timeresults
    experiment
   end
  methods
    function self=WaterfalldiagrammTwoSided(rotorsystem, experiment)  
        % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
            %    :type experiment: object
            %    :return: Object for two sided Waterfall diagram 
      self.rotorsystem = rotorsystem;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
    end 
  end
      
end



