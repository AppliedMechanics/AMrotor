classdef Fourierorbitdarstellung < handle
  
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
      self.ColorHandler.setUp(length(experiment.drehzahlen));
     end
     


     
 end
    
end

