function [x,EVmain] = plot_displacements(obj)

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.set_up(n_ew);

  % plotten der Moden
  figure('Name','Eigenschwingformen x','NumberTitle','off');
  ax = axes;
    title('Eigenmoden Lateral-Richtung x')
    hold on;

    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    EVx = obj.modalsystem.eigenVectors.lateral_x;
    EVy = obj.modalsystem.eigenVectors.lateral_y;
    EW = imag(obj.modalsystem.eigenValues.lateral);
    for s=1:n_ew
        plotMode(ax,x,EVx(:,s),...
                       EW(s),...
                       ColorHandler.getColor(s))
    end

    legend('show')
    grid('on')

    if isfield(obj.modalsystem.eigenVectors,'lateral_y')
        figure('Name','Eigenschwingformen y','NumberTitle','off');
        ax = axes;
        title('Eigenmoden Lateral-Richtung y')
        hold on;

        for s=1:n_ew
            plotMode(ax,x,EVy(:,s),EW(s),ColorHandler.getColor(s))
        end

        legend('show')
        grid('on')
        
        
        figure('Name','Eigenschwingformen sqrt(x^2+y^2)','NumberTitle','off');
        ax = axes;
        title('Eigenschwingformen r=sqrt(x^2+y^2)')
        hold on;

        for s=1:n_ew
            plotMode(ax,x,sqrt(EVx(:,s).^2+EVy(:,s).^2),EW(s),...
                ColorHandler.getColor(s))
        end

        legend('show')
        grid('on')
        
        figure('Name','Eigenschwingformen in Hauptachsen','NumberTitle','off');
        ax = axes;
        title('Eigenschwingformen in Hauptachsen')
        hold on;
        
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
            plotMode(ax,x,EVmain(:,s),EW(s),...
                ColorHandler.getColor(s))
        end

        legend('show')
        grid('on')
    end
    
end