classdef Eigenschwingformen < handle
% Eigenschwingformen Class for visualisation of the eigen modes
   properties %(Access = private)
      name='Rotor Eigenschwingformen'
      % See also AMrotorSIM.Experiments.Modalanalyse
      modalsystem
      % See also AMrotorTools.PlotColors
      ColorHandler;
   end
   methods
       %Konstruktor
       function obj = Eigenschwingformen(a)
         if nargin == 0
           disp('Keine Visualierung möglich ohne Modalsystem')
         else
           obj.modalsystem = a;
         end
       end
   end
   
   methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_color_number(obj)
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = obj.modalsystem.get_number_of_eigenvalues();
            obj.ColorHandler.set_up(num.all);
        end
   end
        
end
