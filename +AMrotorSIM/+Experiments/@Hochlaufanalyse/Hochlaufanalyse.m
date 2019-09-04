classdef Hochlaufanalyse < handle
% Hochlaufanalyse Class for time integration of run-up
%   Does time integration for the system with a linearly rising rotational
%   speed
% See also AMrotorSIM.Graphs
   properties
      name='Hochlaufanalyse'
      % See also AMrotorSIM.Rotorsystem
      rotorsystem@AMrotorSIM.Rotorsystem 
      drehzahlen    % rpm steps
      time          % time steps e.g. 0:tStep:tEnd
      result        % results-struct: result.X, result.X_d, result.X_dd
   end
   methods
       function obj = Hochlaufanalyse(a,rpm_span,time)
       % obj = Hochlaufanalyse(rotorsystem,rpm_span,time)
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