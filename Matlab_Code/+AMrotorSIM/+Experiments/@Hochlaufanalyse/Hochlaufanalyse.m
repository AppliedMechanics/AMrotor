classdef Hochlaufanalyse < handle
   properties
      name='Hochlaufanalyse'
      rotorsystem
      rpm_span
      time
      result
   end
   methods
       %Konstruktor
       function obj = Hochlaufanalyse(a,rpm_span,time)
         if nargin == 0
           disp('Keine Hoclaufanalyse möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.rpm_span = rpm_span;
           obj.time = time;
         end
       end 
   end
end