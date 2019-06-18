classdef Orbit < handle
   properties
    unit
    rotorsystem
    name=' --- Graphobject Orbits  --- '
    time
    experiment
    ColorHandler
   end
   methods
       %Konstruktor
       function obj = Orbit(r, experiment)
          self.rotorsystem = r;
          self.time = experiment.time;
          self.experiment = experiment;
          self.ColorHandler = AMrotorTools.PlotColors();
          self.ColorHandler.set_up(length(experiment.drehzahlen));
       end
      
      function show(obj)
         disp(obj.name);
      end
 
   end
   methods(Access=private)
       
   end
end