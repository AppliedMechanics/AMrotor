classdef TimeSignal < handle
   properties
    unit
    rotorsystem
    name=' --- Graphobject Zeitsignale  --- '
    time
    experiment
    ColorHandler
   end
  methods
  function self=TimeSignal(r, experiment) 
      self.rotorsystem = r;
      self.time = experiment.time;
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.setUp(length(experiment.drehzahlen));
  end
      
   end
      
end