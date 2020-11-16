classdef Orbitdarstellung < handle
% Class for visualization of the orbit as result of the time integration

% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
    unit
    rotorsystem
    name=' ---  Orbit  --- '
    experiment
    ColorHandler
   end
  methods
  function self=Orbitdarstellung(rotorsystem, experiment) 
       % Constructor
       %
       %    :parameter rotorsystem: Object of type Rotorsystem
       %    :type rotorsystem: object
       %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
       %    :type experiment: object
       %    :return: Object for Orbit representation of time results
       
      self.rotorsystem = rotorsystem;
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
      
   end
      
end