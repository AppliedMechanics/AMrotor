classdef Waterfalldiagramm < handle
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung  --- '
    abtastrate
    drehzahl
    timeresults
    experiment
   end
  methods
    function self=Waterfalldiagramm(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
    end 
  end
      
end



