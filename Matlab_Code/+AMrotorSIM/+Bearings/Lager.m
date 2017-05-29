classdef Lager < matlab.mixin.Heterogeneous
   properties
      name
      position
   end
   methods
      %Konstruktor
       function obj = Lager(arg)
         if nargin == 0
           obj.name = "starkes Lager!";
         else
           obj.name = arg.name;
           obj.position=arg.position;
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
      
      function [M,K] = compute_matrices(obj)
        disp('Berechne Lagersteifigkeit')
      end
      
   end
end