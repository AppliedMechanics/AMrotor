classdef Waterfalldiagramm < handle
% Class for visualization of the time integration results as one sided Waterfall diagram (for Run-ups)

%    abtastrate... sampling rate
%    drehzahl... rotation speed
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

properties
    unit
    rotorsystem
    name=' --- One sided Waterfalldiagram  --- '
    abtastrate
    drehzahl
    timeresults
    experiment
   end
  methods
    function self=Waterfalldiagramm(rotorsystem, experiment)  
        % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
            %    :type experiment: object
            %    :return: Object for one sided Waterfall diagram 
            
      self.rotorsystem = rotorsystem;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
    end 
  end
      
end



