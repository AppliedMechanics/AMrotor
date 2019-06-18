classdef WaterfalldiagrammTwoSided < handle
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung Two Sided  --- '
    abtastrate
    drehzahl
    timeresults
    experiment
   end
  methods
    function self=WaterfalldiagrammTwoSided(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
    end 
  end
      
end



