% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Fourierdarstellung < handle
% Class for visualization of the time integration results as fourier transform

% abtastrate... sampling rate
properties
    unit
    rotorsystem
    name=' ---  Fourier  --- '
    abtastrate
    experiment
    ColorHandler
   end
  methods
  function self=Fourierdarstellung(rotorsystem, experiment)  
            % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
            %    :type experiment: object
            %    :return: Object for Fourier representation of time results
           
      self.rotorsystem = rotorsystem;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
  

      
   end
      
end

