classdef Stationaere_Lsg < handle
   properties
      name='Station�re L�sung'
      rotorsystem
      drehzahlen
      time        % time steps [S]      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg(a,drehzahlvektor,time)
         if nargin == 0
           disp('Keine L�sung m�glich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahlen = drehzahlvektor;
           obj.time = time;
         end
       end     
   end
end