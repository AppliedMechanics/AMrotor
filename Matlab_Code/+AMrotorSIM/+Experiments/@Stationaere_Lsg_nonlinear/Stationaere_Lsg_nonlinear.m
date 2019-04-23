classdef Stationaere_Lsg_nonlinear < handle
   properties
      name='Stationäre Lösung nichtlinear'
      rotorsystem
      drehzahlen
      time        % time steps [S]      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg_nonlinear(a,drehzahlvektor,time)
         if nargin == 0
           disp('Keine Lösung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahlen = drehzahlvektor;
           obj.time = time;
         end
       end     
   end
end