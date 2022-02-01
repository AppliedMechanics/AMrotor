% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [x,EVmain] = plot_displacements(obj,varargin)
% Plots the eigenshapes in 2D
%
%    :param varargin: Additional argument for complex output ('complex') (check function)
%    :type varargin: char
%    :return: Figures of mode shapes and eigenvectors with corresponding postion alon z-axis

% [x,EVmain] = plot_displacements(obj,varagin)

%  examples:
%  obj.plot_displacements;
%  obj.plot_displacements('complex'); % to plot complex values

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.set_up(n_ew);

    EW = imag(obj.modalsystem.eigenValues.lateral);
    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    EVx = obj.modalsystem.eigenVectors.lateral_x;
    
    % write the data that should be plotted in CellArray
    stringCellArray = {'u_x'};
    EVCellArray = {EVx};

    % append data to plot to CellArrays
    if isfield(obj.modalsystem.eigenVectors,'lateral_y')
        EVy = obj.modalsystem.eigenVectors.lateral_y;
        EVz = obj.modalsystem.eigenVectors.lateral_z;
        EVpsiz = obj.modalsystem.eigenVectors.torsional_psi_z;
        EVr = sqrt(EVx.^2+EVy.^2);
        % rotate the coordinate system for each EV to see the biggest amplitude
        EVmain = zeros(size(EVx));
        for s=1:n_ew
            angle = atan2(EVy(:,s),EVx(:,s));
            angle = mod(angle,2*pi);
            % wrap angle to [0 pi]
            for i = 1:length(angle)
                if angle(i) > pi
                    angle(i) = angle(i)-pi;
                end
            end
            angle = mean(angle);
            EVmain(:,s) = EVx(:,s)*cos(angle) + EVy(:,s)*sin(angle);
        end
        
        stringCellArray = {stringCellArray{1:end},'u_y','u_z','psi_z','r=sqrt(u_x^2+u_y^2)','main axes'};
        EVCellArray = {EVCellArray{1:end}, EVy, EVz, EVpsiz, EVr, EVmain};
    end


    % plot the data in the CellArrays
    for iCell = 1:length(EVCellArray)
            figure('Name',['eigenmodes ',stringCellArray{iCell}],'NumberTitle','off');
            ax = axes;
            title(['eigenmodes ',stringCellArray{iCell}])
            hold on;grid('on');
            for s=1:n_ew
                plotMode(ax,x,EVCellArray{iCell}(:,s),EW(s),ColorHandler.getColor(s))
            end
            legend('show')
    end
    
    % option complex specified?
    inputCell = varargin;
    if any([strcmpi(inputCell,'complex'),strcmpi(inputCell,'c')])
        optComplex = true;
    else 
        optComplex = false;
    end
    if optComplex
        EVx = obj.modalsystem.eigenVectors.lat_complex.x;
        EVy = obj.modalsystem.eigenVectors.lat_complex.y;
        EVz = obj.modalsystem.eigenVectors.lat_complex.z;
        EVpsiz = obj.modalsystem.eigenVectors.lat_complex.psi_z;

        stringCellArray = {'u_x','u_y','u_z','psi_z'};
        EVCellArray = {EVx, EVy, EVz,EVpsiz};
        
        for iCell = 1:length(EVCellArray)
            figure('Name',['eigenmodes ',stringCellArray{iCell}],'NumberTitle','off');
            ax1 = subplot(2,1,1);
            title(['eigenmodes ',stringCellArray{iCell}])
            hold on;grid('on');
            ax2 = subplot(2,1,2);
            hold on;grid('on');
            for s=1:n_ew
                plotMode(ax1,x,real(EVCellArray{iCell}(:,s)),EW(s),ColorHandler.getColor(s))
                plotMode(ax2,x,imag(EVCellArray{iCell}(:,s)),EW(s),ColorHandler.getColor(s))
            end
            ylimits = [min([ax1.YLim,ax2.YLim]), max([ax1.YLim,ax2.YLim])];
            ax1.YLim = ylimits;
            ax2.YLim = ylimits;
            ax1.YLabel.String = 'real(eigenvector)';
            ax2.YLabel.String = 'imag(eigenvector)';
            legend('show')
        end
    end
    
end