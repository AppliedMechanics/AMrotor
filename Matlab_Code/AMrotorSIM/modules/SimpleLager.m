classdef SimpleLager < Lager
   properties
       Steifigkeit
   end
   methods
        function obj=SimpleLager(variable) 
           obj = obj@Lager(variable);
           obj.Steifigkeit = variable.stiffness;
        end 
   end
end