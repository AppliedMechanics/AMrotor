% Licensed under GPL-3.0-or-later, check attached LICENSE file

function set_plots(obj,Selection,varargin)
% Carries out the 3D visualisation of the mode shapes and handles additional parameters
%
%    :param Selection: Additional parameters like 'All', 'Half', 'Overlay', ... (check function)
%    :type Selection: char
%    :param varargin: Variable input argument (check function)
%    :type varargin: char
%    :return: Figures with 3D visualisation of the mode shapes

% Selection options:
%             'All','all','a','A': Plot all mode shapes 
%             'Half','half','h','H': Plot every second mode shape (if mode shapes are symmetric)
%             10 : Plot of the 10th mode shape

% Varargin options:
%             'overlay','o': Mode shapes with the original rotor 
%             'Skip',5: Plot circle at every 5th node along z-axis
%             'tangentialPoints',30: Discretization of the circles (30 points)
%             'scale',3: Multiply eigenvectors by 3 for visualization

% Examples:
%   esf.set_plots('half') % 'all', 'half' or desired mode number
%   esf.set_plots('half','overlay')
%   esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3) specify additional options, first input is index of mode


    obj.set_color_number();
    num = obj.modalsystem.get_number_of_eigenvalues();
    
    paramPlot.scaleEigenvector = obj.get_scale_eigenvector(varargin);
    paramPlot.moduloOfNodesToPlot = obj.get_modulo_of_nodes_to_plot(varargin);
    paramPlot.numberOfTangentialPoints = obj.get_number_of_tangential_points(varargin);
    
    isOverlay = zeros(1,length(varargin));
    for i = 1:length(varargin)
        isOverlay(1,i) = any(strcmpi(varargin{i},{'overlay','o'}));
    end
    isOverlay = any(isOverlay);

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % overlay
    if isOverlay
        if ischar(Selection)
            switch Selection
                case {'All','all','a','A'}
                    for i = 1:1:num.all
                        obj.plot_esf_3D_overlay(i,paramPlot);
                    end
                case {'Half','half','h','H'}
                    for i = 1:2:num.all
                        obj.plot_esf_3D_overlay(i,paramPlot);
                    end
                otherwise
                    error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
            end
        elseif isnumeric(Selection)
            if Selection <= num.all
                obj.plot_esf_3D_overlay(Selection,paramPlot);
            else
                error(['You try to reach a selection for the Mode-Number' ...
                          'of the Modal-Diagram which is too high']);
            end
        else
            error(['You try to reach a selection for the Modal-' ...
                      'Diagram which is not implemented.']);
        end

    else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % no overlay
        if ischar(Selection) % no overlay
            switch Selection
                case {'All','all','a','A'}
                    for i = 1:1:num.all
                        obj.plot_esf_3D(i,paramPlot);
                    end
                case {'Half','half','h','H'}
                    for i = 1:2:num.all
                        obj.plot_esf_3D(i,paramPlot);
                    end
                otherwise
                    error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
            end
        elseif isnumeric(Selection)
            if Selection <= num.all
                obj.plot_esf_3D(Selection,paramPlot);
            else
                error(['You try to reach a selection for the Mode-Number' ...
                              'of the Modal-Diagram which is too high']);
            end
        else
            error(['You try to reach a selection for the Modal-' ...
                      'Diagram which is not implemented.']);
        end
    end
end