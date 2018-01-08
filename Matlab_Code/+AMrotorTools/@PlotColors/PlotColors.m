classdef PlotColors < handle
    %PlotColors Summary of this class goes here
    % This class calculates the needed matrices for the calculation of the
    % campell diagramm and does also the sorting regarding forward/backward
    % whirl
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
        num;
        colors;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        function obj = PlotColors()
        end
        function setUp(obj,nColors)
            obj.num.color = nColors;
            obj.colors = distinguishable_colors(obj.num.color);
        end
        function colorRGBvec = getColor(obj,numEntry)
            colorRGBvec = obj.colors(numEntry,:);
        end
    end
    methods (Access = private)
    end
end