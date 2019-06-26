classdef Hochlaufanalyse < handle
% Hochlaufanalyse Class for time integration of run-up
%   Does time integration for the system with a linearly rising rotational
%   speed
   properties
      name='Hochlaufanalyse'
      rotorsystem
      drehzahlen
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
           obj.drehzahlen = rpm_span;
           obj.time = time;
         end
       end 
   end
end