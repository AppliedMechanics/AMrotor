% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Fourierorbitdarstellung < handle
% Class for visualisation of the orbit provided from the Fourier transform

%that is
% developed from the fourier transform and inverse fourier transform of the
% results of the time integration
% This class's method plot requires the Matlab curve fitting toolbox.
 properties
    unit
    rotorsystem
    name=' ---  Fourierorbit  --- '
    time
    experiment
    ColorHandler
 end
   
 methods
    
     function self=Fourierorbitdarstellung(rotorsystem, experiment) 
            % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter experiment: Object of type Experiments.Stationare_Lsg or Experiments.Hochlaufanalyse
            %    :type experiment: object
            %    :return: Object for Fourierorbit representation of time results
            
          self.rotorsystem = rotorsystem;
          self.time = experiment.time;
          self.experiment = experiment;
          self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
     end
     


     
 end
    
end

