function [x,EVmain] = plot_displacements(obj)
 % plots the eigenshapes in 2D

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.set_up(n_ew);

    % 
    EW = imag(obj.modalsystem.eigenValues.lateral);
    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    EVx = obj.modalsystem.eigenVectors.lateral_x;
    
    % write the data that should be plotted in CellArray
    stringCellArray = {'u_x'};
    EVCellArray = {EVx};

    if isfield(obj.modalsystem.eigenVectors,'lateral_y')
        EVy = obj.modalsystem.eigenVectors.lateral_y;
        EVz = obj.modalsystem.eigenVectors.lateral_z;
        EVpsiz = obj.modalsystem.eigenVectors.torsional_psi_z;

        EVr = sqrt(EVx.^2+EVy.^2);

        % rotate the coordinate system for each EV to see the biggest amplitude
        EVmain = zeros(size(EVx));
        for s=1:n_ew
            angle = atan2(EVy(:,s),EVx(:,s));
            angle = wrapTo2Pi(angle);
            % wrap angle to [0 pi]
            for i = 1:length(angle)
                if angle(i) > pi
                    angle(i) = angle(i)-pi;
                end
            end
            angle = mean(angle);
            EVmain(:,s) = EVx(:,s)*cos(angle) + EVy(:,s)*sin(angle);
        end

        stringCellArray = {stringCellArray{1:end},'u_y','u_z','psi_z','r=sqrt(u_x^2+u_y^2)','main axes'}; %just append
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
    end
    
end