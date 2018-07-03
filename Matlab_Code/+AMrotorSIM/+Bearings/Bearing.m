classdef Bearing < matlab.mixin.Heterogeneous & handle
   properties
      name
      position
      type
      color='black'
   end
   methods
      %Konstruktor
       function obj = Bearing(arg)
         if nargin == 0
           obj.name = 'starkes Lager!';
         else
           obj.name = arg.name;
           obj.position=arg.position;
           obj.type = arg.type;
         end
      end
      
      function print(obj)
         disp(obj.name);
      end
      
      function [M,K] = compute_matrices(obj)
        disp('Compute Matrices Bearings')
      end
      
   end
end