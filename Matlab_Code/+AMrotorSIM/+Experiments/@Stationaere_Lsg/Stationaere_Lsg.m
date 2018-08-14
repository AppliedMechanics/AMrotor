classdef Stationaere_Lsg < handle
   properties
      name='Stationäre Lösung'
      rotorsystem
      drehzahlen
      time        % time steps [S]      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg(a,drehzahlvektor,time)
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