classdef Eigenschwingformen < handle
   properties (Access = private)
      name='Rotor Eigenschwingformen'
      modalsystem
   end
   methods
       %Konstruktor
       function obj = Eigenschwingformen(a)
         if nargin == 0
           disp('Keine Visualierung m�glich ohne Modalsystem')
         else
           obj.modalsystem = a;
         end
       end
   end
end
