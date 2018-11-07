function plot_esf_3D(obj,number_esf,numberOfTangentialPoints,numberOfNodesToPlot) %number_nodes_to_plot used to plot subset of all nodes

  n_ew=obj.modalsystem.n_ew;
  ColorHandler = AMrotorTools.PlotColors();
  ColorHandler.set_up(n_ew);

  % plotten der Moden
  figure('Name',sprintf('Eigenschwingform %i',number_esf),'NumberTitle','off');
  ax = axes;
  title(sprintf('Eigenmode Lateral %1.2f Hz',obj.modalsystem.eigenValues.lateral(number_esf)/(2*pi)))
  hold on;

    x = [obj.modalsystem.rotorsystem.rotor.mesh.nodes.z];
    
    V = obj.modalsystem.eigenVectors.lateral(:,number_esf);
    
    plotMode3D(ax,x,V,...
                       obj.modalsystem.eigenValues.lateral(number_esf),...
                       ColorHandler.getColor(number_esf),numberOfTangentialPoints,numberOfNodesToPlot)

    %legend('show')
    grid('on')
end