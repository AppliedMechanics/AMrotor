classdef Waterfalldiagramm < handle
% Waterfalldiagramm Class for visualisation of the results of the time
% integration as waterfall diagram
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung  --- '
    abtastrate
    drehzahl
    timeresults
    % See also AMrotorSIM.Experiments.Stationaere_Lsg AMrotorSIM.Experiments.Hochlaufanalyse
    experiment
   end
  methods
    function self=Waterfalldiagramm(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
    end 
  end
      
end



