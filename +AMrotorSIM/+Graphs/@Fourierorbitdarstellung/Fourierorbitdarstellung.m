classdef Fourierorbitdarstellung < handle
% FOURIERORBITDARSTELLUNG Class for visualisation of the orbit that is
% developed from the fourier transform and inverse fourier transform of the
% results of the time integration
 properties
    unit
    rotorsystem
    name=' ---  Fourierorbitdarstellung  --- '
    time
    experiment
    ColorHandler
 end
   
 methods
    
     function self=Fourierorbitdarstellung(a, experiment) 
          self.rotorsystem = a;
          self.time = experiment.time;
          self.experiment = experiment;
          self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
     end
     


     
 end
    
end

