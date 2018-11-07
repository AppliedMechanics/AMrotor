function set_plots(obj,Selection,varargin)
    obj.set_color_number();
    num = obj.modalsystem.get_number_of_eigenvalues();
    
    moduloOfNodesToPlot = obj.get_modulo_of_nodes_to_plot(varargin);
    numberOfTangentialPoints = obj.get_number_of_tangential_points(varargin);
    
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
                        obj.plot_esf_3D_overlay(i,numberOfTangentialPoints,moduloOfNodesToPlot);
                    end
                case {'Half','half','h','H'}
                    for i = 1:2:num.all
                        obj.plot_esf_3D_overlay(i,numberOfTangentialPoints,moduloOfNodesToPlot);
                    end
                otherwise
                    error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
            end
        elseif isnumeric(Selection)
            if Selection <= num.all
                obj.plot_esf_3D_overlay(Selection,numberOfTangentialPoints,moduloOfNodesToPlot);
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
                        obj.plot_esf_3D(i,numberOfTangentialPoints,moduloOfNodesToPlot);
                    end
                case {'Half','half','h','H'}
                    for i = 1:2:num.all
                        obj.plot_esf_3D(i,numberOfTangentialPoints,moduloOfNodesToPlot);
                    end
                otherwise
                    error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
            end
        elseif isnumeric(Selection)
            if Selection <= num.all
                obj.plot_esf_3D(Selection,numberOfTangentialPoints,moduloOfNodesToPlot);
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