function set_plots(obj,Selection,varargin)
    obj.set_color_number();
    num = obj.modalsystem.get_number_of_eigenvalues();
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % overlay
    if nargin == 3
    if any(strcmp(varargin,{'Overlay','overlay','o','O'}))
        if ischar(Selection)
            switch Selection
                case {'All','all','a','A'}
                    for i = 1:1:num.all
                        obj.plot_esf_3D_overlay(i);
                    end
                case {'Half','half','h','H'}
                    for i = 1:2:num.all
                        obj.plot_esf_3D_overlay(i);
                    end
                otherwise
                    error(['You try to reach a selection for the Modal-' ...
                          'Diagram which is not implemented.']);
            end
        elseif isnumeric(Selection)
            if Selection <= num.all
                obj.plot_esf_3D_overlay(Selection);
            else
                error(['You try to reach a selection for the Mode-Number' ...
                          'of the Modal-Diagram which is too high']);
            end
        else
            error(['You try to reach a selection for the Modal-' ...
                      'Diagram which is not implemented.']);
        end
    end

    else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % no overlay
    if ischar(Selection) % no overlay
        switch Selection
            case {'All','all','a','A'}
                for i = 1:1:num.all
                    obj.plot_esf_3D(i);
                end
            case {'Half','half','h','H'}
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
            error(['You try to reach a selection for the Mode-Number' ...
                          'of the Modal-Diagram which is too high']);
        end
    else
        error(['You try to reach a selection for the Modal-' ...
                  'Diagram which is not implemented.']);
    end
    end
end