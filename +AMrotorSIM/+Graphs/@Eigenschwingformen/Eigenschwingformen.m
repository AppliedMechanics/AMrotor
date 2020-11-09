classdef Eigenschwingformen < handle
% Class for visualization of the eigenmodes

% See also AMrotorSIM.Experiments.Modalanalyse 
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties %(Access = private)
      name='Rotor vibration modes'
      modalsystem
      ColorHandler;
   end
   methods
       function obj = Eigenschwingformen(modalanalysis)
            % Constructor
            %
            %    :parameter modalanalysis: Object of type Experiments.Modalanalyse
            %    :type modalanalysis: object
            %    :return: Object for visualization of eigenmodes
         if nargin == 0
           disp('No visualization possible without modal system')
         else
           obj.modalsystem = modalanalysis;
         end
       end
   end
   
   methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_color_number(obj)
        % (private) Assigns colors to all eigenvalues 
        %
        %    :return: Assigned color to eigenvalues
        
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = obj.modalsystem.get_number_of_eigenvalues();
            obj.ColorHandler.set_up(num.all);
        end
   end
        
end
