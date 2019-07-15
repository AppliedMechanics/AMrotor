classdef Stationaere_Lsg < handle
% Stationaere_Lsg Class for time integration with constant roation speed
%   Does the time intergation of the system for steps of constant
%   rotational speed. Run-up with steps of constant rotation speeds is
%   possible.
   properties
      name='Stationäre Lösung'
      % See also AMrotorSIM.Rotorsystem
      rotorsystem
      drehzahlen    % rpm steps
      time        	% time steps e.g. 0:tStep:tEnd
      result        % results-struct: result.X, result.X_d, result.X_dd
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