classdef TimeSignal < handle
% TimeSignal Class for visualisation of the signal over time as result of
% the time integration
   properties
    unit
    rotorsystem
    name=' --- Graphobject Zeitsignale  --- '
    time
    % See also AMrotorSIM.Experiments.Stationaere_Lsg AMrotorSIM.Experiments.Hochlaufanalyse
    experiment
    % See also AMrotorTools.PlotColors
    ColorHandler
   end
  methods
  function self=TimeSignal(r, experiment) 
      self.rotorsystem = r;
      self.time = experiment.time;
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
      
   end
      
end