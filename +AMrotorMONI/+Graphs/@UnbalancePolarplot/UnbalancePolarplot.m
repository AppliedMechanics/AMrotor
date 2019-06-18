classdef UnbalancePolarplot < handle
    %UNBALANCEPOLARPLOT Summary of this class goes here
    %   Plots the unbalance matrices in a 2D Polarplot
    
    properties
        Monitor
        name='-----Unbalance Polarplot-------'
    end
    
    methods
        
     function self=UnbalancePolarplot(name,a) 
      self.name=name;
      self.Monitor = a;
     end
  
    plot(self)

    end
    
end

