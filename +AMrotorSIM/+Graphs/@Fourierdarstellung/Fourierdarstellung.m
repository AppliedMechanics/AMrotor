classdef Fourierdarstellung < handle
% Fourierdarstellung Class for visualisation of the results of the time
% integration as fouier transform
   properties
    unit
    rotorsystem
    name=' ---  Fourierdarstellung  --- '
    abtastrate
    % See also AMrotorSIM.Experiments.Stationaere_Lsg AMrotorSIM.Experiments.Hochlaufanalyse
    experiment
    % See also AMrotorTools.PlotColors
    ColorHandler
   end
  methods
  function self=Fourierdarstellung(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
  

      
   end
      
end

