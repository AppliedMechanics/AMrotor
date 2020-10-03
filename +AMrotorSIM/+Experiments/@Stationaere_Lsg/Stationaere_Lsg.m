% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Stationaere_Lsg < handle
% Class for time integration with constant roation speed (Stationary solution)

%   Does the time intergation of the system for steps of constant
%   rotational speed. Run-up with steps of constant rotation speeds is
%   possible.
%       drehzahlen... rpm steps
%       time... time steps e.g. 0:tStep:tEnd
%       result... results-struct: result.X, result.X_d, result.X_dd
% See also AMrotorSIM.Graphs
   properties
      name='Stationary solution'
      rotorsystem (1,1) AMrotorSIM.Rotorsystem
      drehzahlen    
      time        	
      result        
   end
   methods
       
       function obj = Stationaere_Lsg(rotorsystem,drehzahlvektor,time)
            % Constructor
            %
            %    :parameter rotorsystem: Object of class Rotorsystem
            %    :type rotorsystem: object
            %    :parameter drehzahlvektor: Rotation speed
            %    :type drehzahlvektor: vector
            %    :parameter time: Time range
            %    :type time: vector
            %    :return: Stationary solution object
           
           % obj = Stationaere_Lsg(a,drehzahlvektor,time)
         if nargin == 0
           disp('Keine Lösung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = rotorsystem;
           obj.drehzahlen = drehzahlvektor;
           obj.time = time;
         end
       end     
   end
end