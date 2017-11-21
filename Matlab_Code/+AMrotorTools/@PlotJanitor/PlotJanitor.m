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
    %   (0.01,0.05)-----------------O
    %
    %   This setting can be changed with 
    %   PlotJanitor.setArea(leftLowerCorner,rightUpperCorner) where the
    %   both inputs vectors are.
    %   Moreover the default layout is that it consits of 2 rows and 3
    %   columns; but this can also be changed with 
    %   PlotJanitor.setLayout(rows,cols)
    %   If there are more plots than cols*rows than the plots of the next
    %   levels will be offset by default of [0.01 0.01] from the location
    %   of the plot underneath it. This values can be again changed with
    %   PlotJanitor.setOffset([x,y]) in normalized coordinates.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
        rows;
        cols;
        offset;
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
            obj.leftLowerCorner = [0.01,0.05];
            obj.rightUpperCorner = [0.95,0.95];
            obj.rows = 2;
            obj.cols = 3;
            obj.offset = [0.01,0.01];
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
        function setOffset(obj,offset)
            obj.offset = offset;
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
            levels = ceil(length(figHandles)/(obj.rows*obj.cols));
            for f = 1:length(figHandles)
                h = figHandles(length(figHandles)-f+1);
                pos = obj.getPositions(f);
                fac = obj.getLevel(f,levels);
                set(h,'Units','normalized','outerposition',...
                    [fac*obj.offset + obj.positions{pos}(1:2),...
                     0.98*obj.positions{pos}(3:4)]);
            end
            pause(0.1);
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
                    obj.positions{(r-1)*obj.cols+c} = [pos.x,pos.y,figureSize];
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
        function fac = getLevel(obj,numberFigure,levels)
            fac = 0;
            for l = 1:levels
                tmp = numberFigure - l*obj.rows*obj.cols;
                if tmp <= 0
                    fac = l - 1;
                    break;
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end

