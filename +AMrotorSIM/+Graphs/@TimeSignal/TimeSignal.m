% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef TimeSignal < handle
% Class for visualisation of the signal over time as result of the time integration
   properties
    unit
    rotorsystem
    name=' --- Graphobject Time signal  --- '
    time
    experiment
    ColorHandler
   end
  methods
  function self=TimeSignal(rotorsystem, experiment) 
      % Constructor
       %
       %    :parameter rotorsystem: Object of type Rotorsystem
       %    :type rotorsystem: object
       %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
       %    :type experiment: object
       %    :return: Object for the representation of the time results
       
      self.rotorsystem = rotorsystem;
      self.time = experiment.time;
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
      
   end
      
end