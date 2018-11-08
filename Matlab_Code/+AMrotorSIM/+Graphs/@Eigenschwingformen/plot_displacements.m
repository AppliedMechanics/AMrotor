function plot_displacements(obj)

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.set_up(n_ew);

  % plotten der Moden
  figure('Name','Eigenschwingformen x','NumberTitle','off');
  ax = axes;
    title('Eigenmoden Lateral-Richtung x')
    hold on;

    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    for s=1:n_ew
        plotMode(ax,x,obj.modalsystem.eigenVectors.lateral_x(:,s),...
                       obj.modalsystem.eigenValues.lateral(s),...
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
            plotMode(ax,x,obj.modalsystem.eigenVectors.lateral_y(:,s),...
                obj.modalsystem.eigenValues.lateral(s),...
                ColorHandler.getColor(s))
        end

        legend('show')
        grid('on')
    end
    
end