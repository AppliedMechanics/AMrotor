function [figurehandle] = show(obj)
% Plots the overall rotor system
%
%    :return: Figure of rotor system

% Licensed under GPL-3.0-or-later, check attached LICENSE file

     disp(obj.name);
     %-----------------------------------------------------------------
    figure;
    figurehandle = axes('xlim', [-10 10], 'ylim', [-10 10], 'zlim',[-10 10]);
    view(3);
    grid on;
    axis equal;
    hold on
    xlabel('z')
    ylabel('y')
    zlabel('x')

     %-----------------------------------------------------------------

    plot_rotor(figurehandle,obj.rotorsystem.rotor);
    plot_components(figurehandle,obj.rotorsystem.components,obj.rotorsystem.rotor);
    plot_sensors(figurehandle,obj.rotorsystem.sensors);
    plot_loads(figurehandle,obj.rotorsystem.loads);
    plot_pidController(figurehandle,obj.rotorsystem.pidControllers,obj.rotorsystem.rotor);

         
end