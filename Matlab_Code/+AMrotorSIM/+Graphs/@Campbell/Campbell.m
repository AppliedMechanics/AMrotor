classdef Campbell < handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties %(Access = private)
        Name = 'Campbell-Diagramm';
        experimentCampbell;
        ColorHandler;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Konstruktor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Campbell(experimentCampbell)
            if nargin == 0
                disp(['Without a Campell analaysis a Campbell-Diagram' ...
                      ' is not possible'])
            else
                obj.experimentCampbell = experimentCampbell;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_plots(obj,Selection)
            obj.set_color_number();
            switch Selection
                case {'Forward','forward','f','F'}
                    obj.set_forward_plots();
                    obj.set_forward_plots_damping_ratio();
                case {'Backward','backward','b','B'}
                    obj.set_backward_plots();
                    obj.set_backward_plots_damping_ratio();
                case {'All','all','a','A'}
                    obj.set_all_plots();
                    obj.set_all_plots_damping_ratio();
                otherwise
                    error(['You try to reach a selection for the Campbell-' ...
                          'Diagram which is not implemented.']);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_color_number(obj)
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = obj.experimentCampbell.get_number_of_eigenvalues();
            obj.ColorHandler.set_up(num.all);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set_forward_plots(obj);
        set_backward_plots(obj);
        set_all_plots(obj);
    end
    methods (Access = public)
        print_damping_zero_crossing(obj);
        print_critical_speeds(obj)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end