classdef WaterfalldiagrammTwoSided < handle
% WaterfalldiagrammTwoSided Class for visualisation of the results of the
% time integration as a two sided waterfall diagram
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



