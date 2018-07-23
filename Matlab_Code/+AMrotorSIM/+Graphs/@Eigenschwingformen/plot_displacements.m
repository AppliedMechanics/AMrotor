function plot_displacements(obj)

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.setUp(n_ew);

  % plotten der Moden
  figure('Name','Eigenschwingformen','NumberTitle','off');
  ax = axes;
    title('Eigenmoden Lateral-Richtung')
    hold on;

    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    for s=1:n_ew
        plotMode(ax,x,obj.modalsystem.eigenVectors.lateral(:,s),...
                       obj.modalsystem.eigenValues.lateral(s),...
                       ColorHandler.getColor(s))
    end

    legend('show')
    grid('on')
end