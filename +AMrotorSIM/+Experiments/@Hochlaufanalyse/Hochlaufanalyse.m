classdef Hochlaufanalyse < handle
% Class for time integration of run-up
%
% See also AMrotorSIM.Graphs

%   Does time integration for the system with a linearly rising rotational
%   speed
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties
      name='Run-up'
      rotorsystem (1,1) AMrotorSIM.Rotorsystem 
      drehzahlen; % rpm steps    
      time; % time steps e.g. 0:tStep:tEnd          
      result; % results-struct: result.X, result.X_d, result.X_dd         
   end
   methods
       function obj = Hochlaufanalyse(rotorsystem,rpm_span,time)
            % Constructor
            %
            %    :parameter rotorsystem: Object of type Rotorsystem
            %    :type rotorsystem: object
            %    :parameter rpm_span: Rotation speed steps
            %    :type rpm_span: vector (double)
            %    :parameter time: Time range
            %    :type time: vector (double)
            %    :return: Run-up object
            
         if nargin == 0
           disp('No run-up possible without Rotorsystem')
         else
           obj.rotorsystem = rotorsystem;
           obj.drehzahlen = rpm_span;
           obj.time = time;
         end
       end 
   end
end