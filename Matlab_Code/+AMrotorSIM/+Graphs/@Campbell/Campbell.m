classdef Campbell < handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
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
                disp(['Without a Campell analaysis a Campbell-Diagreamm' ...
                      ' is not possible'])
            else
                obj.experimentCampbell = experimentCampbell;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setPlots(obj,Selection)
            obj.setColorNumber();
            switch Selection
                case {'Forward','forward','f','F'}
                    obj.setForwardPlots();
                case {'Backward','backward','b','B'}
                    obj.setBackwardPlots();
                case {'All','all','a','A'}
                    obj.setAllPlots();
                otherwise
                    error(['You try to reach a selection for the Campbell-' ...
                          'Diagramm which is not implemented.']);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setColorNumber(obj)
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = obj.experimentCampbell.getNumberOfEigenValues();
            obj.ColorHandler.setUp(num.all);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        setForwardPlots(obj);
        setBackwardPlots(obj);
        setAllPlots(obj);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end