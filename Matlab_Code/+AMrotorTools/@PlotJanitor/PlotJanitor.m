classdef PlotJanitor < handle
    %PLOTJANITOR Summary of this class goes here
    %   This is a class which has the purpose of reordering the open
    %   figures such that all open figures are visible all the time
    %   The default area for the plots is in normalized coordinates
    %
    %   O-----------------(0.95,0.95)
    %   |                           |
    %   |                           |
    %   |                           |
    %   (0.05,0.05)-----------------O
    %
    %   This setting can be changed with 
    %   PlotJanitor.setLayout(leftLowerCorner,rightUpperCorner) where the
    %   both inputs vectors are.
    %   Moreover the default layout is that it consits of 2 rows and 3
    %   columns; but this can also be changed with 
    %   PlotJanitor.setLayout(rows,cols)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        rows;
        cols;
        leftLowerCorner;
        rightUpperCorner;
        positions;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Konstruktor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = PlotJanitor()
            obj.leftLowerCorner = [0.05,0.05];
            obj.rightUpperCorner = [0.95,0.95];
            obj.rows = 2;
            obj.cols = 3;
            disp('Created PlotJanitor....')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setLayout(obj,rows,cols)
            obj.rows = rows;
            obj.cols = cols;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setArea(obj,leftLowerCorner,rightUpperCorner)
            obj.leftLowerCorner = leftLowerCorner;
            obj.rightUpperCorner = rightUpperCorner;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function cleanFigures(obj)
            figHandles = get(groot, 'Children');
            obj.setPositions();
            for f = 1:length(figHandles)
                h = figHandles(length(figHandles)-f+1);
                pos = obj.getPositions(f);
                set(h,'Units','normalized','outerposition',obj.positions{pos});
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setPositions(obj)
            clear('obj.positions');
            obj.positions = cell(1,obj.rows*obj.cols);
            delta.x = obj.rightUpperCorner(1)-obj.leftLowerCorner(1);
            delta.y = obj.rightUpperCorner(2)-obj.leftLowerCorner(2);
            figureSize = [delta.x/obj.cols,delta.y/obj.rows];
            for r = 1:obj.rows
                for c = 1:obj.cols
                    pos.x = obj.leftLowerCorner(1) + (c-1)*figureSize(1);
                    pos.y = obj.leftLowerCorner(2) + (obj.rows-r)*figureSize(2);
                    obj.positions{(r-1)*obj.cols+c} = [pos.x,pos.y,0.98*figureSize];
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function pos = getPositions(obj,numberFigure)
            pos = mod(numberFigure,obj.rows*obj.cols);
            if pos == 0
                pos = obj.rows*obj.cols;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end

