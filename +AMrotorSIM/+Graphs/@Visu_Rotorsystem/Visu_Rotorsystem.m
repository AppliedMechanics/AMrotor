classdef Visu_Rotorsystem < handle
% Visu_Rotorsystem Class for visualisation of the rotor system
   properties
      name='Rotor Gesamtsystem'
      % See also AMrotorSIM.Rotorsystem
      rotorsystem
   end
   methods
       function obj = Visu_Rotorsystem(a)
         if nargin == 0
           disp('Kein Geometrieanzeige möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
   end
   methods(Access=private)
       
   end
end