classdef Eigenschwingformen < handle
   properties (Access = private)
      name='Rotor Eigenschwingformen'
      modalsystem
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
   
       function set_plots(obj,Selection)
            obj.set_color_number();
            num = obj.modalsystem.get_number_of_eigenvalues();
            if ischar(Selection) 
                switch Selection
                    case {'All','all','a','A'}
                        for i = 1:2:num.all
                            obj.plot_esf_3D(i);
                        end
                    otherwise
                        error(['You try to reach a selection for the Modal-' ...
                              'Diagram which is not implemented.']);
                end
            elseif isnumeric(Selection)
                if Selection <= num.all
                    obj.plot_esf_3D(Selection);
                else
                    error(['You try to reach a selection for the Modal-' ...
                              'Diagram which is not implemented.']);
                end
            else
                error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
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
