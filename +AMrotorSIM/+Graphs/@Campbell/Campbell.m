classdef Campbell < handle
% Campbell Class for the visualisation of a Campbell diagram
%   Can plot the classic Campbell diagram, which shows the eigenfrequncies
%   over the rotational speed.
%   Can also plot the damping over rotational speed.
    properties %(Access = private)
        Name = 'Campbell-Diagramm';
        % See also AMrotorSIM.Experiments.Campbell
        experimentCampbell;
        % See also AMrotorTools.PlotColors
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
        % main method to call by the user
        %   set_plots(obj,Selection)
        %   Selection: 'all','forward','backward'
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
        [rpmZeroCrossingForward, rpmZeroCrossingBackward]=print_damping_zero_crossing(obj);
        print_critical_speeds(obj)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end